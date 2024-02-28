defmodule PolarWeb.RootLiveTest do
  use PolarWeb.ConnCase

  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Product

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

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
        serial: "20240209-12",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62dd",
            size: 876,
            path: "images/alpine/edge/amd64/default/20240209-12/incus.tar.xz"
          },
          %{
            name: "root.squashfs",
            file_type: "squashfs",
            hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690d2",
            size: 2_982_800,
            path: "images/alpine/edge/amd64/default/20240209-12/rootfs.tar.xz"
          }
        ]
      })

    {:ok, _version} =
      Streams.create_version(product, %{
        serial: "20240209-13",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62de",
            size: 876,
            path: "images/alpine/edge/amd64/default/20240209-13/incus.tar.xz"
          },
          %{
            name: "root.squashfs",
            file_type: "squashfs",
            hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690de",
            size: 2_982_800,
            path: "images/alpine/edge/amd64/default/20240209-13/rootfs.tar.xz"
          }
        ]
      })

    {:ok, product: product, credential: credential}
  end

  test "GET /" do
    conn = get(build_conn(), "/")

    assert html_response(conn, 200)
  end

  describe "filter" do
    test "render only filtered os" do
      {:ok, _lv, html} = live(build_conn(), ~p"/?os=alpine")

      assert html =~ "3.19"
    end

    test "does not render anything" do
      {:ok, _lv, html} = live(build_conn(), ~p"/?os=strange")

      refute html =~ "3.19"
    end
  end
end
