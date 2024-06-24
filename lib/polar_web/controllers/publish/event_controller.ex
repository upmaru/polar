defmodule PolarWeb.Publish.EventController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Streams.Version

  action_fallback PolarWeb.FallbackController

  def create(conn, %{
        "version_id" => version_id,
        "event" => event_params
      }) do
    with %Version{} = version <- Repo.get(Version, version_id) do
      transit_and_render(conn, version, event_params)
    end
  end

  alias Polar.Machines.Assessment

  def create(conn, %{
        "assessment_id" => assessment_id,
        "event" => event_params
      }) do
    with %Assessment{} = assessment <- Repo.get(Assessment, assessment_id) do
      transit_and_render(conn, assessment, event_params)
    end
  end

  defp transit_and_render(
         %{assigns: %{current_user: user}} = conn,
         resource,
         %{"name" => event_name}
       ) do
    with {:ok, %{event: event}} <- Eventful.Transit.perform(resource, user, event_name) do
      conn
      |> put_status(:created)
      |> render(:create, %{event: event})
    end
  end
end
