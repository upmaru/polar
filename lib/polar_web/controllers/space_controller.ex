defmodule PolarWeb.SpaceController do
  use PolarWeb, :controller

  action_fallback PolarWeb.FallbackController

  def show(conn, %{"space_token" => _space_token}) do
    redirect(conn, to: ~p"/")
  end
end
