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
      assert {:ok, space} = Accounts.create_space(user, %{name: "opsmaru"})
    end
  end
end
