defmodule Polar.Machines.Cluster.TransitionsTest do
  use Polar.DataCase, async: true

  alias Polar.Machines

  import Polar.AccountsFixtures

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

  describe "connect" do
    test "can transition", %{user: user, cluster: cluster} do
      assert {:ok, %{resource: connecting_cluster, trigger: trigger}} =
               Eventful.Transit.perform(cluster, user, "connect")

      assert %Oban.Job{worker: "Polar.Machines.Cluster.Connect"} = trigger

      assert connecting_cluster.current_state == "connecting"
    end
  end
end
