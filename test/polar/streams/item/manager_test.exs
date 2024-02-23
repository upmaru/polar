defmodule Polar.Streams.Item.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Accounts
  alias Polar.Streams
  alias Polar.Streams.Product
  alias Polar.Streams.Item

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  setup do
    user = user_fixture()

    {:ok, space} = Accounts.create_space(user, %{name: "test-item-increment"})

    {:ok, credential} =
      Accounts.create_space_credential(space, user, %{
        expires_in: 1_296_000,
        name: "test",
        type: "lxd"
      })

    {:ok, credential: credential}
  end

  setup do
    {:ok, %Product{} = product} =
      Streams.create_product(valid_product_attributes("alpine:3.19:amd64:default"))

    {:ok, version} =
      Streams.create_version(product, valid_version_attributes())

    [item1, _item2] = version.items

    {:ok, item: item1}
  end

  describe "record_item_access/2" do
    test "creates item_access", %{item: item, credential: credential} do
      assert %Item.Access{count: count} = Streams.record_item_access(item, credential)

      assert count == 1
    end

    test "increment item_access count", %{item: item, credential: credential} do
      %Item.Access{count: count} = Streams.record_item_access(item, credential)

      assert %Item.Access{count: incremented_count} = Streams.record_item_access(item, credential)

      assert incremented_count > count
    end
  end
end
