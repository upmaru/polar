defmodule PolarWeb.Publish.StorageControllerTest do
  use PolarWeb.ConnCase

  import Polar.AccountsFixtures

  alias Polar.Accounts

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

    {:ok, conn: conn}
  end

  describe "GET /publish/storage" do
    test "successfully get storage", %{conn: conn} do
      conn = get(conn, "/publish/storage")

      assert %{"data" => data} = json_response(conn, 200)

      assert %{
               "access_key_id" => _access_key_id,
               "secret_access_key" => _secret_access_key,
               "bucket" => _bucket,
               "region" => _region,
               "endpoint" => _endpoint
             } = data
    end
  end
end
