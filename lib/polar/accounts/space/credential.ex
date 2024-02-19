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
    field :current_state, :string, default: "created"

    field :token, :binary
    field :access_count, :integer, default: 0

    field :type, :string

    field :expires_in, :integer, virtual: true
    field :expires_at, :utc_datetime
    field :last_accessed_at, :utc_datetime_usec

    belongs_to :space, Space

    timestamps(type: :utc_datetime_usec)
  end

  def expires_in_range, do: @expires_in_range

  @doc false
  def changeset(credential, attrs) do
    expires_in_range_values = Enum.map(@expires_in_range, fn r -> r.value end)

    credential
    |> cast(attrs, [:expires_in, :type])
    |> generate_token()
    |> validate_inclusion(:expires_in, expires_in_range_values)
    |> validate_inclusion(:type, ["lxd", "incus"])
    |> maybe_set_expires_at()
    |> validate_required([:token])
  end

  defp maybe_set_expires_at(changeset) do
    if expires_in = get_change(changeset, :expires_in) do
      expires_at =
        DateTime.utc_now()
        |> DateTime.truncate(:second)
        |> DateTime.add(expires_in)

      put_change(changeset, :expires_at, expires_at)
    else
      changeset
    end
  end

  defp generate_token(changeset) do
    token =
      :crypto.strong_rand_bytes(12)
      |> Base.encode16()
      |> String.downcase()

    put_change(changeset, :token, token)
  end
end
