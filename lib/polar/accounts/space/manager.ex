defmodule Polar.Accounts.Space.Manager do
  alias Polar.Repo
  alias Polar.Accounts
  alias Polar.Accounts.Space

  import Ecto.Query, only: [from: 2]

  def create(%Accounts.User{} = owner, params) do
    %Space{owner_id: owner.id}
    |> Space.changeset(params)
    |> Repo.insert()
  end

  def get_credential(token: token) do
    Repo.get_by(Space.Credential, token: token)
  end

  def create_credential(%Accounts.Space{} = space, user, params) do
    %Space.Credential{space_id: space.id}
    |> Space.Credential.changeset(params)
    |> Repo.insert()
    |> case do
      {:ok, credential} ->
        {:ok, %{resource: active_credential}} =
          Eventful.Transit.perform(credential, user, "activate")

        {:ok, active_credential}

      error ->
        error
    end
  end

  def increment_credential_access(%Space.Credential{id: credential_id}) do
    from(
      c in Accounts.Space.Credential,
      where: c.id == ^credential_id
    )
    |> Repo.update_all(inc: [access_count: 1])
  end
end
