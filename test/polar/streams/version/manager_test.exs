defmodule Polar.Streams.Version.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Streams

  setup do
    product =
      Streams.get_or_create_product!(%{
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

    {:ok, product: product}
  end

  describe "create_version" do
    test "can successfully create new version", %{product: product} do
      assert {:ok, _version} =
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
    end
  end
end
