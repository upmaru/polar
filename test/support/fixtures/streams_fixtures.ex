defmodule Polar.StreamsFixtures do
  def valid_product_attributes("alpine:3.19:amd64:default") do
    %{
      aliases: ["alpine/3.19", "alpine/3.19/default"],
      arch: "amd64",
      os: "Alpine",
      release: "3.19",
      release_title: "3.19",
      variant: "default",
      requirements: %{
        "secureboot" => "false"
      }
    }
  end

  def valid_version_attributes(serial \\ 1) do
    hash1 =
      :crypto.strong_rand_bytes(32)
      |> Base.encode16()
      |> String.downcase()

    hash2 =
      :crypto.strong_rand_bytes(32)
      |> Base.encode16()
      |> String.downcase()

    %{
      serial: "20240209-#{serial}",
      items: [
        %{
          name: "lxd.tar.gz",
          file_type: "lxd.tar.gz",
          hash: hash1,
          is_metadata: true,
          size: 876,
          path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz"
        },
        %{
          name: "root.squashfs",
          file_type: "squashfs",
          hash: hash2,
          size: 2_982_800,
          path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
        }
      ]
    }
  end
end
