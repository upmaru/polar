defmodule PolarWeb.Publish.Testing.AssessmentJSON do
  alias Polar.Machines.Assessment

  def create(%{assessment: assessment}) do
    %{data: data(assessment)}
  end

  defp data(%Assessment{} = assessment) do
    %{
      id: assessment.id,
      current_state: assessment.current_state,
      check: %{
        slug: assessment.check.slug
      }
    }
  end
end
