defmodule PolarWeb.Publish.Testing.ClusterController do
  use PolarWeb, :controller

  alias Polar.Machines

  action_fallback PolarWeb.FallbackController

  def index(conn, _params) do
    clusters = Machines.list_clusters(:for_testing)

    render(conn, :index, %{clusters: clusters})
  end
end
