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

  def change(%Space{} = space, attrs \\ %{}) do
    Space.changeset(space, attrs)
  end

  def get_credential(token: token) do
    Space.Credential.scope(:active, Space.Credential)
    |> Repo.get_by(token: token)
  end

  def change_credential(credential_or_changeset, attrs \\ %{}) do
    Space.Credential.changeset(credential_or_changeset, attrs)
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

  def credential_valid?(nil), do: false

  def credential_valid?(%Space.Credential{expires_at: expires_at} = credential) do
    if is_nil(expires_at) || DateTime.compare(expires_at, DateTime.utc_now()) == :gt do
      true
    else
      bot = Accounts.Automation.get_bot!()

      Eventful.Transit.perform(credential, bot, "expire")

      false
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
