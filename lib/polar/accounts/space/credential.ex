defmodule Polar.Accounts.Space.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Accounts.Space

  alias __MODULE__.Transitions
  alias __MODULE__.Event

  use Eventful.Transitable

  Transitions
  |> governs(:current_state, on: Event)

  @expires_in_range [
    %{label: "15", value: 1_296_000},
    %{label: "30", value: 2_592_000},
    %{label: "60", value: 5_184_000},
    %{label: "90", value: 7_776_000},
    %{label: "Never", value: nil}
  ]

  schema "space_credentials" do
    field :current_state, :string, default: "active"

    field :token, :binary
    field :access_count, :integer, default: 0

    field :expires_at, :utc_datetime
    field :last_accessed_at, :utc_datetime

    belongs_to :space, Space

    timestamps(type: :utc_datetime_usec)
  end

  def expires_in_range, do: @expires_in_range

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
