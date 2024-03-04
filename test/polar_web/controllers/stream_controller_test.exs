defmodule PolarWeb.StreamControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Product

  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

    password = Accounts.generate_automation_password()

    _bot = bot_fixture(%{password: password})

    {:ok, space} = Accounts.create_space(user, %{name: "some-test-123"})

    {:ok, credential} =
      Accounts.create_space_credential(space, user, %{
        expires_in: 1_296_000,
        name: "test-02",
        type: "lxd"
      })

    {:ok, %Product{} = product} =
      Streams.create_product(%{
        aliases: ["alpine/3.18", "alpine/3.18/default"],
        arch: "amd64",
        os: "Alpine",
        release: "3.19",
        release_title: "3.19",
        variant: "default",
        requirements: %{
          secureboot: false
        }
      })

    {:ok, _version} =
      Streams.create_version(product, %{
        serial: "20240209_13:00",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62dd",
            size: 876,
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

    {:ok, product: product, credential: credential}
  end

  test "GET /spaces/:space_token/streams/v1/index.json", %{
    product: product,
    credential: credential
  } do
    conn = get(build_conn(), "/spaces/#{credential.token}/streams/v1/index.json")

    assert %{"index" => index} = json_response(conn, 200)

    assert %{"images" => images} = index

    assert %{"products" => products} = images

    assert Product.key(product) in products
  end

  test "returns 404 due to invalid token" do
    conn = get(build_conn(), "/spaces/non-existent/streams/v1/index.json")

    assert json_response(conn, 404)
  end
end
