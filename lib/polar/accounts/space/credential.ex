defmodule Polar.Accounts.Space.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  schema "space_credentials" do
    field :current_state, :string, default: "active"

    field :token, :binary
    field :access_count, :integer, default: 0

    field :expires_at, :utc_datetime
    field :last_accessed_at, :utc_datetime

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(space_token, attrs) do
    space_token
    |> cast(attrs, [:expires_at])
    |> generate_token()
    |> validate_required([:token])
  end

  defp generate_token(changeset) do
    token =
      :crypto.strong_rand_bytes(12)
      |> Base.encode16()
      |> String.downcase()

    put_change(changeset, :token, token)
  end
end
