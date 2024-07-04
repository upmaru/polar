defmodule Polar.Machines.Cluster.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Machines

  describe "create cluster" do
    test "successfully create cluster" do
      assert {:ok, cluster} =
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

      assert %Machines.Cluster.Credential{private_key: _private_key, certificate: _certificate} =
               cluster.credential

      assert Enum.count(cluster.instance_wait_times) == 2
    end
  end
end
