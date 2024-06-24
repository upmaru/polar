defmodule Polar.Machines.Assessment.Manager do
  alias Polar.Repo
  alias Polar.Machines.Assessment

  def create(check, params) do
    %Assessment{check_id: check.id}
    |> Assessment.changeset(params)
    |> Repo.insert()
  end
end
