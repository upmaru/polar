defmodule Polar.Machines do
  alias __MODULE__.Cluster

  defdelegate list_clusters(scope),
    to: Cluster.Manager,
    as: :list

  defdelegate create_cluster(params),
    to: Cluster.Manager,
    as: :create

  alias __MODULE__.Check

  defdelegate create_check(params),
    to: Check.Manager,
    as: :create

  alias __MODULE__.Assessment

  defdelegate create_assessment(check, params),
    to: Assessment.Manager,
    as: :create
end
