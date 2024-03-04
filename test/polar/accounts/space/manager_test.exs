defmodule Polar.Accounts.Space.ManagerTest do
  use Polar.DataCase, async: true

  import Polar.AccountsFixtures

  alias Polar.Repo
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
               Accounts.create_space_credential(space, user, %{
                 expires_in: 1_296_000,
                 name: "test",
                 type: "lxd"
               })

      assert byte_size(credential.token) == 24
    end
  end

  describe "credential_valid?" do
    setup %{user: user} do
      password = Accounts.generate_automation_password()

      _bot = bot_fixture(%{password: password})

      {:ok, space} = Accounts.create_space(user, %{name: "test-validity"})

      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test",
          type: "lxd"
        })

      {:ok, credential: credential}
    end

    test "is valid", %{credential: credential} do
      assert Accounts.space_credential_valid?(credential)
    end

    test "not valid", %{credential: credential} do
      changeset =
        Ecto.Changeset.cast(
          credential,
          %{
            expires_at: DateTime.add(DateTime.utc_now(), -1_297_000)
          },
          [:expires_at]
        )

      {:ok, credential} = Repo.update(changeset)

      refute Accounts.space_credential_valid?(credential)

      credential = Repo.reload(credential)

      assert credential.current_state == "expired"
    end
  end
end
