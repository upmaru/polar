defmodule Polar.Machines.Cluster.Manager do
  alias Polar.Repo
  alias Polar.Machines.Cluster

  def create(params) do
    %Cluster{}
    |> Cluster.changeset(params)
    |> Repo.insert()
  end
end
