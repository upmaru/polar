defmodule PolarWeb.Publish.Testing.AssessmentControllerTest do
  use PolarWeb.ConnCase

  alias Polar.Accounts
  alias Polar.Machines
  alias Polar.Streams

  import Polar.AccountsFixtures
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

    {:ok, version: version, cluster: cluster, check: check, conn: conn}
  end

  describe "POST /publish/testing/versions/:version_id/assessments" do
    test "successfully create assessment", %{
      version: version,
      conn: conn,
      check: check,
      cluster: cluster
    } do
      conn =
        post(conn, ~p"/publish/testing/versions/#{version.id}/assessments", %{
          "assessment" => %{
            "check_id" => check.id,
            "cluster_id" => cluster.id
          }
        })

      assert %{"data" => data} = json_response(conn, 201)

      assert %{"id" => _id, "current_state" => "created", "check" => _check} = data
    end
  end
end
