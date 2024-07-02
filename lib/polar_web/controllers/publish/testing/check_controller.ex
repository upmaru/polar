defmodule PolarWeb.Publish.Testing.CheckController do
  use PolarWeb, :controller

  alias Polar.Machines

  action_fallback PolarWeb.FallbackController

  def index(conn, _params) do
    checks = Machines.list_checks()

    render(conn, :index, %{checks: checks})
  end
end
