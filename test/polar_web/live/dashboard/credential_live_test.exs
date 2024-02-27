defmodule PolarWeb.Dashboard.CredentialLiveTest do
  use PolarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  alias Polar.Accounts

  setup %{conn: conn} do
    user = user_fixture()

    {:ok, space} = Accounts.create_space(user, %{name: "test-space-123"})

    {:ok, credential} =
      Accounts.create_space_credential(space, user, %{
        expires_in: 1_296_000,
        name: "test-cred",
        type: "lxd"
      })

    conn = log_in_user(conn, user)

    %{conn: conn, user: user, space: space, credential: credential}
  end

  describe "credential detail" do
    test "can see detail of credential", %{conn: conn, space: space, credential: credential} do
      {:ok, _lv, html} =
        live(conn, ~p"/dashboard/spaces/#{space.id}/credentials/#{credential.id}")

      assert html =~ "lxc remote add opsmaru"
    end
  end
end
