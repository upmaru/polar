defmodule PolarWeb.Dashboard.SpaceLiveTest do
  use PolarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  alias Polar.Accounts

  setup %{conn: conn} do
    user = user_fixture()

    {:ok, space} = Accounts.create_space(user, %{name: "test-space-123"})

    conn = log_in_user(conn, user)

    %{conn: conn, user: user, space: space}
  end

  describe "Space page" do
    test "render space detail", %{conn: conn, space: space} do
      {:ok, _lv, html} = live(conn, ~p"/dashboard/spaces/#{space.id}")

      assert html =~ "No credential"
    end

    test "create new credential", %{conn: conn, space: space} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/#{space.id}")

      lv
      |> element("a", "Create new credential")
      |> render_click()

      assert_redirect(lv, ~p"/dashboard/spaces/#{space.id}/credentials/new")
    end
  end

  describe "with existing credential" do
    setup %{space: space, user: user} do
      {:ok, credential} =
        Accounts.create_space_credential(space, user, %{
          expires_in: 1_296_000,
          name: "test-cred",
          type: "lxd"
        })

      %{credential: credential}
    end

    test "can see existing credential", %{conn: conn, space: space, credential: credential} do
      {:ok, _lv, html} = live(conn, ~p"/dashboard/spaces/#{space.id}")

      assert html =~ credential.name
    end

    test "click on view credential", %{conn: conn, space: space, credential: credential} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/#{space.id}")

      lv
      |> element("#credential_#{credential.id} a", "View credential")
      |> render_click()

      assert_redirect(lv, ~p"/dashboard/spaces/#{space.id}/credentials/#{credential.id}")
    end
  end
end
