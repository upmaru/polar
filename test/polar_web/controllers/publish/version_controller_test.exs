defmodule PolarWeb.Publish.VersionControllerTest do
  use PolarWeb.ConnCase

  import Polar.AccountsFixtures
  import Polar.StreamsFixtures

  alias Polar.Accounts
  alias Polar.Streams

  import Polar.StreamsFixtures

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

  describe "GET /publish/products/:product_id/versions/:id" do
    setup do
      product_attributes = valid_product_attributes("alpine:3.19:amd64:default")

      {:ok, product} = Streams.create_product(product_attributes)

      {:ok, version} =
        Streams.create_version(product, valid_version_attributes(2))

      {:ok, product: product, version: version}
    end

    test "can fetch existing version", %{conn: conn, product: product, version: version} do
      conn = get(conn, "/publish/products/#{product.id}/versions/#{version.serial}")

      assert %{"data" => data} = json_response(conn, 200)

      assert %{"id" => _id} = data
    end
  end

  describe "POST /publish/products/:product_id/versions" do
    setup do
      product_attributes = valid_product_attributes("alpine:3.19:amd64:default")

      {:ok, product} = Streams.create_product(product_attributes)

      {:ok, product: product}
    end

    test "successfully create version for product", %{conn: conn, product: product} do
      conn =
        post(conn, "/publish/products/#{product.id}/versions", %{
          version: %{
            serial: "20240209_13:00",
            items: [
              %{
                name: "lxd.tar.gz",
                file_type: "lxd.tar.gz",
                hash: "35363f3d086271ed5402d61ab18ec03987bed51758c00079b8c9d372ff6d62dd",
                size: 876,
                is_metadata: true,
                path: "images/alpine/edge/amd64/default/20240209_13:00/incus.tar.xz",
                combined_hashes: [
                  %{
                    name: "combined_squashfs_sha256",
                    hash: "a9f02be498bf52b7bac7b5b1cfceb115878d257ad86a359a969e61fbd4bfe0bf"
                  }
                ]
              },
              %{
                name: "root.squashfs",
                file_type: "squashfs",
                hash: "47cc4070da1bf17d8364c390…3603f4ed7e9e46582e690d2",
                size: 2_982_800,
                path: "images/alpine/edge/amd64/default/20240209_13:00/rootfs.tar.xz"
              }
            ]
          }
        })

      assert %{"data" => data} = json_response(conn, 201)

      assert %{"id" => _id} = data
    end
  end
end
