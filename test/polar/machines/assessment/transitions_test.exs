defmodule Polar.Machines.Assessment.TransitionsTest do
  use Polar.DataCase, async: true

  alias Polar.Machines
  alias Polar.Streams

  import Polar.StreamsFixtures
  import Polar.AccountsFixtures

  setup do
    user = user_fixture()

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

    {:ok, assessment} =
      Machines.create_assessment(check, %{
        version_id: version.id,
        cluster_id: cluster.id
      })

    {:ok, assessment: assessment, user: user}
  end

  describe "transitions" do
    test "run", %{assessment: assessment, user: user} do
      assert {:ok, %{resource: resource}} = Eventful.Transit.perform(assessment, user, "run")

      assert resource.current_state == "running"
    end

    test "pass", %{assessment: assessment, user: user} do
      {:ok, %{resource: running_assessment}} = Eventful.Transit.perform(assessment, user, "run")

      assert {:ok, %{resource: resource}} =
               Eventful.Transit.perform(running_assessment, user, "pass")

      assert resource.current_state == "passed"
    end

    test "fail", %{assessment: assessment, user: user} do
      {:ok, %{resource: running_assessment}} = Eventful.Transit.perform(assessment, user, "run")

      assert {:ok, %{resource: resource}} =
               Eventful.Transit.perform(running_assessment, user, "fail")

      assert resource.current_state == "failed"
    end
  end
end
