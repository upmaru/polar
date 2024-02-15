defmodule PolarWeb.Publish.SessionControllerTest do
  use PolarWeb.ConnCase

  import Polar.AccountsFixtures

  alias Polar.Accounts

  setup do
    password = Accounts.generate_automation_password()

    bot_fixture(%{password: password})

    {:ok, password: password}
  end

  describe "POST /publish/sessions" do
    test "can authenticate", %{password: password} do
      conn = post(build_conn(), "/publish/sessions", %{user: %{password: password}})

      assert %{"data" => data} = json_response(conn, 201)

      assert %{"token" => _token} = data
    end
  end
end
