defmodule PolarWeb.Publish.Testing.AssessmentController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Machines

  alias Polar.Streams.Version

  alias PolarWeb.Params.Assessment

  action_fallback PolarWeb.FallbackController

  def create(conn, %{
        "version_id" => version_id,
        "assessment" => assessment_params
      }) do
    with %Version{} = check <- Repo.get(Version, version_id),
         {:ok, assessment_params} <- Assessment.parse(assessment_params),
         {:ok, assessment} <-
           Machines.get_or_create_assessment(check, Map.from_struct(assessment_params)) do
      assessment = Repo.preload(assessment, [:check])

      conn
      |> render(:create, %{assessment: assessment})
    end
  end
end
