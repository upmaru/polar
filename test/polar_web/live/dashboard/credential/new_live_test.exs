defmodule PolarWeb.Dashboard.Credential.NewLiveTest do
  use PolarWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Polar.AccountsFixtures

  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Accounts.Space

  setup %{conn: conn} do
    user = user_fixture()

    conn = log_in_user(conn, user)

    {:ok, space} = Accounts.create_space(user, %{name: "test-space-456"})

    %{conn: conn, space: space}
  end

  describe "New credential creation" do
    test "create credential", %{conn: conn, space: space} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/#{space.id}/credentials/new")

      lv
      |> form("#new-credential-form", %{
        "credential" => %{"name" => "new-cred-test", "type" => "lxd", "expires_in" => "2592000"}
      })
      |> render_submit()

      credential = Repo.get_by!(Space.Credential, name: "new-cred-test")

      assert_redirect(lv, ~p"/dashboard/spaces/#{space.id}/credentials/#{credential.id}")
    end

    test "validation", %{conn: conn, space: space} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/#{space.id}/credentials/new")

      lv
      |> form("#new-credential-form")
      |> render_change(%{
        "credential" => %{"name" => "new-cred-test"}
      })

      assert render(lv) =~ "can&#39;t be blank"
    end

    test "create new credential with testing release channel", %{conn: conn, space: space} do
      {:ok, lv, _html} = live(conn, ~p"/dashboard/spaces/#{space.id}/credentials/new")

      lv
      |> form("#new-credential-form", %{
        "credential" => %{
          "name" => "new-cred-test-testing",
          "type" => "lxd",
          "release_channel" => "testing",
          "expires_in" => "2592000"
        }
      })
      |> render_submit()

      credential = Repo.get_by!(Space.Credential, name: "new-cred-test-testing")

      assert credential.release_channel == "testing"

      {:ok, lv, _html} =
        live(conn, ~p"/dashboard/spaces/#{space.id}/credentials/#{credential.id}")

      assert render(lv) =~ "testing"
    end
  end
end
