defmodule Polar.Machines.Assessment.ManagerTest do
  use Polar.DataCase, async: true

  alias Polar.Machines
  alias Polar.Streams

  import Polar.StreamsFixtures

  setup do
    {:ok, check} =
      Machines.create_check(%{
        name: "ipv4-issuing",
        description: "issue ipv4 correctly"
      })

    {:ok, cluster} =
      Machines.create_cluster(%{
        name: "example",
        type: "lxd",
        arch: "amd64",
        credential_endpoint: "some.cluster.com:8443",
        credential_password: "sometoken",
        credential_password_confirmation: "sometoken"
      })

    {:ok, product} =
      Streams.create_product(%{
        aliases: ["alpine/3.19", "alpine/3.19/default"],
        arch: "amd64",
        os: "Alpine",
        release: "3.19",
        release_title: "3.19",
        variant: "default",
        requirements: %{
          secureboot: "false"
        }
      })

    {:ok, version} =
      Streams.create_version(product, valid_version_attributes(2))

    {:ok, check: check, cluster: cluster, version: version}
  end

  describe "create assessment" do
    test "successfully create assessment", %{check: check, cluster: cluster, version: version} do
      assert {:ok, assessment} =
               Machines.create_assessment(version, %{
                 check_id: check.id,
                 cluster_id: cluster.id
               })

      assert assessment.current_state == "created"
    end
  end
end
