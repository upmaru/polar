defmodule Polar.Accounts.Space.ManagerTest do
  use Polar.DataCase, async: true

  import Polar.AccountsFixtures

  alias Polar.Accounts

  setup do
    user = user_fixture()

    {:ok, user: user}
  end

  describe "create_space" do
    test "can create space for owner", %{user: user} do
      assert {:ok, _space} = Accounts.create_space(user, %{name: "opsmaru"})
    end
  end

  describe "create_space_credential" do
    setup %{user: user} do
      {:ok, space} = Accounts.create_space(user, %{name: "some-test"})

      {:ok, space: space}
    end

    test "create credential for space", %{space: space, user: user} do
      assert {:ok, credential} =
               Accounts.create_space_credential(space, user, %{expires_in: 1_296_000, type: "lxd"})

      assert byte_size(credential.token) == 24
    end
  end
end
