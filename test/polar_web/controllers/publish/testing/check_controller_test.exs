defmodule PolarWeb.Publish.Testing.CheckControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Accounts
  alias Polar.Machines

  import Polar.AccountsFixtures

  setup do
    password = Accounts.generate_automation_password()

    bot = bot_fixture(%{password: password})

    user = Accounts.get_user_by_email_and_password(bot.email, password)

    session_token =
      Accounts.generate_user_session_token(user)
      |> Base.encode64()

    conn =
      build_conn()
      |> put_req_header("authorization", session_token)

    {:ok, _check} =
      Machines.create_check(%{
        name: "ipv4-issuing",
        description: "checks that ipv4 is correctly issued"
      })

    {:ok, conn: conn}
  end

  describe "GET /publish/testing/checks" do
    test "get list of available checks", %{conn: conn} do
      conn = get(conn, "/publish/testing/checks")

      assert %{"data" => data} = json_response(conn, 200)

      assert Enum.count(data) == 1
    end
  end
end
