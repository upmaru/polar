defmodule PolarWeb.Publish.Version.EventController do
  use PolarWeb, :controller

  alias Polar.Repo
  alias Polar.Streams.Version

  action_fallback PolarWeb.FallbackController

  def create(%{assigns: %{current_user: current_user}} = conn, %{
        "version_id" => version_id,
        "event" => %{"name" => event_name}
      }) do
    with %Version{} = version <- Repo.get(Version, version_id),
         {:ok, %{event: event}} <- Eventful.Transit.perform(version, current_user, event_name) do
      conn
      |> put_status(:created)
      |> render(:create, %{event: event})
    end
  end
end
