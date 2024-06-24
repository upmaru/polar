defmodule PolarWeb.Publish.Testing.AssessmentController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Machines

  alias Polar.Machines.Check

  def create(conn, %{
        "check_id" => check_id,
        "assessment" => assessment_params
      }) do
    with %Check{} = check <- Repo.get(Check, check_id),
         {:ok, assessment} <- Machines.create_assessment(check, assessment_params) do
      assessment = Repo.preload(assessment, [:check])

      render(conn, :create, %{assessment: assessment})
    end
  end
end
