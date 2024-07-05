defmodule Polar.Streams.Version.PruningTest do
  use Polar.DataCase, async: true
  use Oban.Testing, repo: Polar.Repo

  import Polar.AccountsFixtures

  alias Polar.Repo
  alias Polar.Accounts

  alias Polar.Streams
  alias Polar.Streams.Product
  alias Polar.Streams.Version
  alias Polar.Streams.Version.Pruning

  setup do
    password = Accounts.generate_automation_password()

    bot = bot_fixture(%{password: password})

    {:ok, bot: bot}
  end

  setup %{bot: bot} do
    {:ok, %Product{} = with_active_versions} =
      Streams.create_product(%{
        aliases: ["alpine/3.18", "alpine/3.18/default"],
        arch: "amd64",
        os: "Alpine",
        release: "3.18",
        release_title: "3.18",
        variant: "default",
        requirements: %{
          secureboot: "false"
        }
      })

    {:ok, version} =
      Streams.create_version(with_active_versions, %{
        serial: "20240209-36",
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

    {:ok, another_version} =
      Streams.create_version(with_active_versions, %{
        serial: "20240209-37",
        items: [
          %{
            name: "lxd.tar.gz",
            file_type: "lxd.tar.gz",
            hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62aa",
            size: 876,
            path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz"
          },
          %{
            name: "root.squashfs",
            file_type: "squashfs",
            hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690aa",
            size: 2_982_800,
            path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
          }
        ]
      })

    {:ok, %{resource: testing_version}} = Eventful.Transit.perform(version, bot, "test")

    {:ok, %{resource: another_testing_version}} =
      Eventful.Transit.perform(another_version, bot, "test")

    expired =
      DateTime.utc_now()
      |> DateTime.add(-4, :day)

    query = from(v in Version, where: v.id == ^version.id)

    Repo.update_all(query, set: [inserted_at: expired])

    {:ok, version: testing_version, another_version: another_testing_version}
  end

  describe "perform" do
    test "successfully deactivate expired version", %{
      version: version,
      another_version: another_version
    } do
      assert version.current_state == "testing"
      assert another_version.current_state == "testing"

      assert :ok = perform_job(Pruning, %{})

      version = Repo.reload(version)

      assert version.current_state == "inactive"
      assert another_version.current_state == "testing"
    end
  end
end
