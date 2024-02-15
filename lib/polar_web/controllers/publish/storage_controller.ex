defmodule PolarWeb.Publish.StorageController do
  use PolarWeb, :controller

  action_fallback PolarWeb.FallbackController

  def show(%{assigns: %{current_user: _current_user}} = conn, _params) do
    config = Polar.AWS.config()

    render(conn, :show, %{storage: config})
  end
end
