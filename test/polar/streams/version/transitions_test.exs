defmodule Polar.Streams.Version.TransitionsTest do
  use Polar.DataCase, async: true

  alias Polar.Accounts
  alias Polar.Streams

  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

    password = Accounts.generate_automation_password()

    bot = bot_fixture(%{password: password})

    {:ok, product} =
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

    {:ok, %{resource: testing_version}} = Eventful.Transit.perform(version, bot, "test")

    {:ok, %{resource: active_version}} =
      Eventful.Transit.perform(testing_version, bot, "activate")

    {:ok, user: user, version: active_version}
  end

  describe "deactivate" do
    test "can deactivate active version", %{version: version, user: user} do
      assert {:ok, %{resource: inactive_version}} =
               Eventful.Transit.perform(version, user, "deactivate")

      assert inactive_version.current_state == "inactive"
    end
  end
end
