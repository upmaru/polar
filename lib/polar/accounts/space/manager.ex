defmodule Polar.Accounts.Space.Manager do
  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Accounts.Space

  def create(%Accounts.User{} = owner, params) do
    %Space{owner_id: owner.id}
    |> Space.changeset(params)
    |> Repo.insert()
  end

  def create_credential(%Accounts.Space{} = space, params) do
    %Space.Credential{space_id: space.id}
    |> Space.Credential.changeset(params)
    |> Repo.insert()
  end
end
