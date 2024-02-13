defmodule Polar.Accounts.Space.Manager do
  alias Polar.Accounts.Space

  def create(owner, params) do
    %Space{owner_id: owner.id}
    |> Space.changeset(params)
    |> Repo.insert()
  end

  def create_credential(space, params) do
  end
end
