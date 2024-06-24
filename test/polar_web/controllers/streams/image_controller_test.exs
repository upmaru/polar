defmodule PolarWeb.Streams.ImageControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Accounts
  alias Polar.Streams

  alias Polar.Streams.Product

  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

    password = Accounts.generate_automation_password()

    _bot = bot_fixture(%{password: password})

    {:ok, space} = Accounts.create_space(user, %{name: "some-test-item"})

    {:ok, %Product{} = product_with_testing} =
      Streams.create_product(%{
        aliases: ["alpine/3.19", "alpine/3.19/default"],
        arch: "amd64",
        os: "Alpine",
        release: "3.19",
        release_title: "3.19",
        variant: "default",
        requirements: %{
          secureboot: false
        }
      })

    {:ok, version} =
      Streams.create_version(product_with_testing, %{
        serial: "20240209_13:00",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62dd",
            size: 876,
            is_metadata: true,
            path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz"
          },
          %{
            name: "root.squashfs",
            file_type: "squashfs",
            hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690d2",
            size: 2_982_800,
            path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
          }
        ]
      })

    {:ok, %{resource: _testing_version}} =
      Eventful.Transit.perform(version, user, "test")

    {:ok, %Product{} = product_without_testing} =
      Streams.create_product(%{
        aliases: ["alpine/3.20", "alpine/3.20/default"],
        arch: "amd64",
        os: "Alpine",
        release: "3.20",
        release_title: "3.20",
        variant: "default",
        requirements: %{
          secureboot: false
        }
      })

    {:ok, version} =
      Streams.create_version(product_without_testing, %{
        serial: "20240209_13:00",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62aa",
            size: 876,
            is_metadata: true,
            path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz"
          },
          %{
            name: "root.squashfs",
            file_type: "squashfs",
            hash: "67cc4070da1bf17d8364c390…3603f4ed7e9e46582e690d1",
            size: 2_982_800,
            path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
          }
        ]
      })

    {:ok, %{resource: testing_version}} =
      Eventful.Transit.perform(version, user, "test")

    {:ok, %{resource: _active_version}} =
      Eventful.Transit.perform(testing_version, user, "activate")

    {:ok,
     space: space,
     user: user,
     product_with_testing: product_with_testing,
     product_without_testing: product_without_testing}
  end

  describe "product with testing version" do
    setup %{space: space, user: user} do
      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test-02",
          type: "lxd",
          release_channel: "testing"
        })

      {:ok, credential: credential}
    end

    test "GET /spaces/:space_token/images.json", %{
      credential: credential,
      product_without_testing: product_without_testing
    } do
      conn = get(build_conn(), ~s"/spaces/#{credential.token}/streams/v1/images.json")

      assert %{"products" => products} = json_response(conn, 200)

      product_keys = Map.keys(products)

      assert Product.key(product_without_testing) not in product_keys
    end
  end

  describe "product with active version" do
    setup %{space: space, user: user} do
      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test-02",
          type: "lxd",
          release_channel: "active"
        })

      {:ok, credential: credential}
    end

    test "GET /spaces/:space_token/images.json", %{
      credential: credential,
      product_with_testing: product_with_testing
    } do
      conn = get(build_conn(), ~s"/spaces/#{credential.token}/streams/v1/images.json")

      assert %{"products" => products} = json_response(conn, 200)

      product_keys = Map.keys(products)

      assert Product.key(product_with_testing) not in product_keys
    end
  end
end
