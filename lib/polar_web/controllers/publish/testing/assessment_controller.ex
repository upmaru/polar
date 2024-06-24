defmodule PolarWeb.Publish.Testing.AssessmentController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Machines

  alias Polar.Streams.Version

  def create(conn, %{
        "version_id" => version_id,
        "assessment" => assessment_params
      }) do
    with %Version{} = check <- Repo.get(Version, version_id),
         {:ok, assessment} <- Machines.create_assessment(check, assessment_params) do
      assessment = Repo.preload(assessment, [:check])

      conn
      |> put_status(:created)
      |> render(:create, %{assessment: assessment})
    end
  end
end
