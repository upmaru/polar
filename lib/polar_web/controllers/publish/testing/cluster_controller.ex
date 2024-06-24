defmodule PolarWeb.Publish.Testing.ClusterController do
  use PolarWeb, :controller

  alias Polar.Machines

  def index(conn, _params) do
    clusters = Machines.list_clusters(:for_testing)

    render(conn, :index, %{clusters: clusters})
  end
end
