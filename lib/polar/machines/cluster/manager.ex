defmodule Polar.Machines.Cluster.Manager do
  alias Polar.Repo
  alias Polar.Machines.Cluster

  import Ecto.Query, only: [where: 3]

  def list(:for_testing) do
    Cluster
    |> where([c], c.current_state == "healthy")
    |> Repo.all()
  end

  def create(params) do
    %Cluster{}
    |> Cluster.changeset(params)
    |> Repo.insert()
  end
end
