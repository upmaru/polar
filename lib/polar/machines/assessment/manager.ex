defmodule Polar.Machines.Assessment.Manager do
  alias Polar.Repo
  alias Polar.Machines.Assessment

  def create(version, params) do
    %Assessment{version_id: version.id}
    |> Assessment.changeset(params)
    |> Repo.insert()
  end
end
