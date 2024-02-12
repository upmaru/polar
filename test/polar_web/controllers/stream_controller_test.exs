defmodule PolarWeb.StreamControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Streams
  alias Polar.Streams.Product

  setup do
    %Product{} =
      product =
      Streams.get_or_create_product!(%{
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

    {:ok, product: product}
  end

  test "GET /streams/v1/index.json", %{product: product} do
    conn = get(build_conn(), "/streams/v1/index.json")

    assert %{"index" => index} = json_response(conn, 200)

    assert %{"images" => images} = index

    assert %{"products" => products} = images

    assert Product.key(product) in products
  end
end
