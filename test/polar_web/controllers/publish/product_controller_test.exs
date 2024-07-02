defmodule PolarWeb.Publish.ProductControllerTest do
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

    {:ok, conn: conn}
  end

  describe "unauthenticated" do
    test "returns unauthenticated" do
      id =
        ["alpine", "3.19", "amd64", "default"]
        |> Enum.join(":")
        |> Base.url_encode64()

      conn = get(build_conn(), "/publish/products/#{id}")

      assert json_response(conn, 401)
    end
  end

  describe "GET /publish/products/:id" do
    setup do
      product_attributes = valid_product_attributes("alpine:3.19:amd64:default")

      {:ok, _product} = Streams.create_product(product_attributes)

      :ok
    end

    test "successfully get product", %{conn: conn} do
      id =
        ["alpine", "3.19", "amd64", "default"]
        |> Enum.join(":")
        |> Base.url_encode64()

      conn = get(conn, "/publish/products/#{id}")

      assert %{"data" => data} = json_response(conn, 200)

      assert %{"id" => _id, "key" => _key, "requirements" => requirements} = data

      assert %{"secureboot" => "false"} = requirements
    end
  end
end
