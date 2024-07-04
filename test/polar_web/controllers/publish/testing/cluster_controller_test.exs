defmodule PolarWeb.Publish.Testing.ClusterControllerTest do
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

    {:ok, cluster} =
      Machines.create_cluster(%{
        name: "example",
        type: "lxd",
        arch: "amd64",
        credential_endpoint: "some.cluster.com:8443",
        credential_password: "sometoken",
        credential_password_confirmation: "sometoken",
        instance_wait_times: [
          %{type: "vm", duration: 10_000},
          %{type: "container", duration: 5_000}
        ]
      })

    {:ok, _created_cluster} =
      Machines.create_cluster(%{
        name: "example2",
        type: "lxd",
        arch: "amd64",
        credential_endpoint: "some.cluster.com:8443",
        credential_password: "sometoken",
        credential_password_confirmation: "sometoken",
        instance_wait_times: [
          %{type: "vm", duration: 10_000},
          %{type: "container", duration: 5_000}
        ]
      })

    {:ok, conn: conn, cluster: cluster, user: user}
  end

  describe "GET /publish/testing/clusters" do
    setup %{cluster: cluster, user: user} do
      {:ok, %{resource: connecting_cluster}} =
        Eventful.Transit.perform(cluster, user, "connect")

      {:ok, %{resource: _healthy_cluster}} =
        Eventful.Transit.perform(connecting_cluster, user, "healthy")

      {:ok, cluster: cluster}
    end

    test "list healthy clusters", %{conn: conn, cluster: cluster} do
      conn =
        get(conn, "/publish/testing/clusters")

      assert %{"data" => data} = json_response(conn, 200)

      assert cluster.id in Enum.map(data, & &1["id"])

      cluster = List.first(data)

      assert %{"instance_wait_times" => instance_wait_times} = cluster

      assert Enum.count(instance_wait_times) == 2
    end
  end
end
