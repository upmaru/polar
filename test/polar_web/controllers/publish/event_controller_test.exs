defmodule PolarWeb.Publish.EventControllerTest do
  use PolarWeb.ConnCase

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  alias Polar.Accounts
  alias Polar.Streams

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
      |> put_req_header("content-type", "application/json")

    product_attributes = valid_product_attributes("alpine:3.19:amd64:default")

    {:ok, product} = Streams.create_product(product_attributes)

    {:ok, version} =
      Streams.create_version(product, valid_version_attributes(2))

    {:ok, conn: conn, version: version}
  end

  describe "POST /publish/versions/:version_id/events" do
    test "can create transition event", %{conn: conn, version: version} do
      conn =
        post(conn, "/publish/versions/#{version.id}/events", %{
          event: %{
            name: "test"
          }
        })

      assert %{"data" => data} = json_response(conn, 201)

      assert %{"id" => _id, "name" => "test"} = data
    end
  end
end
