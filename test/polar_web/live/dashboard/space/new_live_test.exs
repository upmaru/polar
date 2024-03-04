defmodule PolarWeb.Dashboard.Space.NewLiveTest do
  use PolarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  alias Polar.Repo
  alias Polar.Accounts.Space

  setup %{conn: conn} do
    user = user_fixture()

    conn = log_in_user(conn, user)

    %{conn: conn}
  end

  describe "New space creation" do
    test "create space", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/new")

      lv
      |> form("#new-space-form", %{"space" => %{"name" => "some-test-space"}})
      |> render_submit()

      space = Repo.get_by!(Space, name: "some-test-space")

      %{"info" => flash} = assert_redirect(lv, ~p"/dashboard/spaces/#{space.id}")

      assert flash =~ "Space successfully created!"
    end
  end
end
