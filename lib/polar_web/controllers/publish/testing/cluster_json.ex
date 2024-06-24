defmodule PolarWeb.Publish.Testing.ClusterJSON do
  alias Polar.Machines.Cluster

  def index(%{clusters: clusters}) do
    %{
      data: Enum.map(clusters, &data/1)
    }
  end

  def data(%Cluster{} = cluster) do
    %{
      id: cluster.id,
      credential: cluster.credential,
      current_state: cluster.current_state
    }
  end
end