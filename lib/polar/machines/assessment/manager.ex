defmodule Polar.Machines.Assessment.Manager do
  alias Polar.Repo
  alias Polar.Machines.Assessment

  def get_or_create(version, params) do
    check_id = Map.get(params, "check_id") || params.check_id
    instance_type = Map.get(params, "instance_type") || params.instance_type

    Assessment
    |> Repo.get_by(
      version_id: version.id,
      check_id: check_id,
      instance_type: instance_type
    )
    |> case do
      %Assessment{} = assessment ->
        assessment

      nil ->
        create(version, params)
    end
  end

  def create(version, params) do
    %Assessment{version_id: version.id}
    |> Assessment.changeset(params)
    |> Repo.insert()
  end
end
