defmodule Polar.Streams.Version.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Streams
  alias Polar.Accounts

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  setup do
    password = Accounts.generate_automation_password()

    _bot = bot_fixture(%{password: password})

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

    {:ok, product: product}
  end

  describe "create_version" do
    test "can successfully create new version", %{product: product} do
      assert {:ok, _version} =
               Streams.create_version(product, valid_version_attributes(2))
    end
  end

  describe "deactivate old version on create" do
    setup %{product: product} do
      {:ok, version} =
        Streams.create_version(product, valid_version_attributes(2))

      %{existing_version: version}
    end

    test "creating a new version deactivates old versions", %{
      product: product,
      existing_version: existing_version
    } do
      assert {:ok, _version} =
               Streams.create_version(product, valid_version_attributes(3))

      existing_version = Repo.reload(existing_version)

      assert existing_version.current_state == "inactive"
    end
  end

  describe "keep 2 previous version" do
    setup %{product: product} do
      Polar.Globals.save("basic", %{versions_per_product: 2})

      {:ok, version3} =
        Streams.create_version(product, valid_version_attributes(3))

      {:ok, version4} =
        Streams.create_version(product, valid_version_attributes(4))

      %{existing_version: version4, to_be_inactive: version3}
    end

    test "create new version deactivate version 3", %{
      product: product,
      existing_version: existing_version,
      to_be_inactive: to_be_inactive
    } do
      assert {:ok, _version} =
               Streams.create_version(product, valid_version_attributes(5))

      to_be_inactive = Repo.reload(to_be_inactive)

      assert to_be_inactive.current_state == "inactive"

      existing_version = Repo.reload(existing_version)

      assert existing_version.current_state == "active"
    end
  end
end
