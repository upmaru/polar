defmodule Polar.Machines.Cluster.ConnectTest do
  use Polar.DataCase, async: true
  use Oban.Testing, repo: Polar.Repo

  alias Polar.Machines
  alias Polar.Machines.Cluster.Connect

  import Polar.AccountsFixtures

  import Mox

  setup :verify_on_exit!

  setup do
    user = user_fixture()

    {:ok, cluster} =
      Machines.create_cluster(%{
        name: "example",
        type: "lxd",
        arch: "amd64",
        credential_endpoint: "some.cluster.com:8443",
        credential_password: "sometoken",
        credential_password_confirmation: "sometoken"
      })

    {:ok, cluster: cluster, user: user}
  end

  describe "perform" do
    setup %{cluster: cluster, user: user} do
      {:ok, %{resource: connecting_cluster}} =
        Eventful.Transit.perform(cluster, user, "connect")

      {:ok, cluster: connecting_cluster}
    end

    test "connect to the cluster", %{cluster: cluster, user: user} do
      Polar.LexdeeMock
      |> expect(:create_certificate, fn _, _ ->
        {:ok, nil}
      end)

      assert {:ok, %{resource: healthy_cluster}} =
               perform_job(Connect, %{cluster_id: cluster.id, user_id: user.id})

      assert healthy_cluster.current_state == "healthy"
    end
  end
end
