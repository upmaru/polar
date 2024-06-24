defmodule PolarWeb.Publish.Testing.AssessmentController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Machines
  alias Polar.Streams.Version

  def create(conn, %{"version_id" => version_id, "assessment" => assessment_params}) do
    with %Version{} = version <- Repo.get(Version, version_id),
         {:ok, assessment} <- Machines.create_assessment(version, assessment_params) do
      render(conn, :create, %{assessment: assessment})
    end
  end
end
