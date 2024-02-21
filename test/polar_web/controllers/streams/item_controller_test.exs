defmodule PolarWeb.Streams.ItemControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Product

  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

    password = Accounts.generate_automation_password()

    _bot = bot_fixture(%{password: password})

    {:ok, space} = Accounts.create_space(user, %{name: "some-test-item"})

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

    {:ok, version} =
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

    item = List.first(version.items)

    {:ok, space: space, user: user, item: item}
  end

  describe "valid credential" do
    setup %{space: space, user: user} do
      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test-02",
          type: "lxd"
        })

      {:ok, credential: credential}
    end

    test "GET /spaces/:space_token/items/:id", %{credential: credential, item: item} do
      conn = get(build_conn(), ~s"/spaces/#{credential.token}/items/#{item.id}")

      assert response(conn, 302)
    end
  end

  describe "invalid credential" do
    setup %{space: space, user: user} do
      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test-02",
          type: "lxd"
        })

      changeset =
        Ecto.Changeset.cast(
          credential,
          %{
            expires_at: DateTime.add(DateTime.utc_now(), -1_297_000)
          },
          [:expires_at]
        )

      {:ok, credential} = Repo.update(changeset)

      {:ok, credential: credential}
    end

    test "GET /spaces/:space_token/items/:id", %{credential: credential, item: item} do
      conn = get(build_conn(), ~s"/spaces/#{credential.token}/items/#{item.id}")

      assert response(conn, 404)
    end
  end
end
