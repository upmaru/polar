defmodule PolarWeb.DashboardLiveTest do
  use PolarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  alias Polar.Accounts

  setup do
    user = user_fixture()

    %{user: user}
  end

  describe "Dashboard page" do
    test "render dashboard", %{conn: conn, user: user} do
      {:ok, _lv, html} =
        conn
        |> log_in_user(user)
        |> live(~p"/dashboard")

      assert html =~ "Your spaces"
      assert html =~ "Create new space"
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/dashboard")

      assert {:redirect, %{to: path, flash: _flash}} = redirect
      assert path == ~p"/users/log_in"
    end
  end

  describe "new space" do
    setup %{conn: conn} do
      user = user_fixture()

      conn = log_in_user(conn, user)

      %{user: user, conn: conn}
    end

    test "creates a new space", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard")

      lv
      |> element("a", "Create new space")
      |> render_click()

      assert_redirect(lv, ~p"/dashboard/spaces/new")
    end
  end

  describe "with existing space" do
    setup %{conn: conn} do
      user = user_fixture()

      {:ok, space} = Accounts.create_space(user, %{name: "example-test-space"})

      conn = log_in_user(conn, user)

      %{space: space, conn: conn}
    end

    test "can see existing space", %{conn: conn, space: space} do
      {:ok, _lv, html} = live(conn, ~p"/dashboard")

      assert html =~ space.name
    end

    test "can click into space", %{conn: conn, space: space} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard")

      lv
      |> element("#space_#{space.id} a", space.name)
      |> render_click()

      assert_redirect(lv, ~p"/dashboard/spaces/#{space.id}")
    end
  end
end
