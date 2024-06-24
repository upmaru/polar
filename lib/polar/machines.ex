defmodule Polar.Machines do
  alias __MODULE__.Cluster

  defdelegate list_clusters(scope),
    to: Cluster.Manager,
    as: :list

  defdelegate create_cluster(params),
    to: Cluster.Manager,
    as: :create
end
