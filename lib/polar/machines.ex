defmodule Polar.Machines do
  alias __MODULE__.Cluster

  defdelegate create_cluster(params),
    to: Cluster.Manager,
    as: :create
end
