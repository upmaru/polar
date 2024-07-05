defmodule Polar.Streams.Version.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Streams
  alias Polar.Accounts

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  setup do
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

    {:ok, product: product, bot: bot}
  end

  describe "create_version" do
    test "can successfully create new version", %{product: product} do
      assert {:ok, _version} =
               Streams.create_version(product, valid_version_attributes(2))
    end
  end

  describe "deactivate old version on create" do
    setup %{product: product, bot: bot} do
      {:ok, version} =
        Streams.create_version(product, valid_version_attributes(2))

      {:ok, %{resource: testing_version}} =
        Eventful.Transit.perform(version, bot, "test")

      {:ok, %{resource: active_version}} =
        Eventful.Transit.perform(testing_version, bot, "activate")

      %{existing_version: active_version}
    end

    test "activating a new version deactivates old versions", %{
      product: product,
      bot: bot,
      existing_version: existing_version
    } do
      assert {:ok, version} =
               Streams.create_version(product, valid_version_attributes(3))

      {:ok, %{resource: testing_version}} =
        Eventful.Transit.perform(version, bot, "test")

      {:ok, %{resource: _active_version}} =
        Eventful.Transit.perform(testing_version, bot, "activate")

      existing_version = Repo.reload(existing_version)

      assert existing_version.current_state == "inactive"
    end
  end

  describe "keep 2 previous version" do
    setup %{product: product, bot: bot} do
      Polar.Globals.save("basic", %{versions_per_product: 2})

      {:ok, version3} =
        Streams.create_version(product, valid_version_attributes(3))

      {:ok, %{resource: testing_version3}} =
        Eventful.Transit.perform(version3, bot, "test")

      {:ok, %{resource: active_version3}} =
        Eventful.Transit.perform(testing_version3, bot, "activate")

      {:ok, version4} =
        Streams.create_version(product, valid_version_attributes(4))

      {:ok, %{resource: testing_version4}} =
        Eventful.Transit.perform(version4, bot, "test")

      {:ok, %{resource: active_version4}} =
        Eventful.Transit.perform(testing_version4, bot, "activate")

      %{existing_version: active_version4, to_be_inactive: active_version3}
    end

    test "create and activate new version deactivate version 3", %{
      product: product,
      bot: bot,
      existing_version: existing_version,
      to_be_inactive: to_be_inactive
    } do
      assert {:ok, version} =
               Streams.create_version(product, valid_version_attributes(5))

      {:ok, %{resource: testing_version}} =
        Eventful.Transit.perform(version, bot, "test")

      {:ok, %{resource: _active_version}} =
        Eventful.Transit.perform(testing_version, bot, "activate")

      to_be_inactive = Repo.reload(to_be_inactive)

      assert to_be_inactive.current_state == "inactive"

      existing_version = Repo.reload(existing_version)

      assert existing_version.current_state == "active"
    end
  end
end
