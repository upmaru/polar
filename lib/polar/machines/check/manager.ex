defmodule Polar.Machines.Check.Manager do
  alias Polar.Repo
  alias Polar.Machines.Check

  def create(params) do
    %Check{}
    |> Check.changeset(params)
    |> Repo.insert()
  end
end
