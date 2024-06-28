defmodule Polar.Machines do
  alias __MODULE__.Cluster

  defdelegate list_clusters(scope),
    to: Cluster.Manager,
    as: :list

  defdelegate create_cluster(params),
    to: Cluster.Manager,
    as: :create

  alias __MODULE__.Check

  defdelegate list_checks(),
    to: Check.Manager,
    as: :list

  defdelegate create_check(params),
    to: Check.Manager,
    as: :create

  alias __MODULE__.Assessment

  defdelegate get_or_create_assessment(version, params),
    to: Assessment.Manager,
    as: :get_or_create
end
