defmodule Polar.Accounts.Space.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Accounts.Space
  alias Polar.Streams.ReleaseChannel

  alias __MODULE__.Transitions
  alias __MODULE__.Event

  use Eventful.Transitable

  Transitions
  |> governs(:current_state, on: Event)

  import Ecto.Query, only: [from: 2]

  @expires_in_range [
    %{label: "15", value: 1_296_000},
    %{label: "30", value: 2_592_000},
    %{label: "60", value: 5_184_000},
    %{label: "90", value: 7_776_000},
    %{label: "Never", value: nil}
  ]

  schema "space_credentials" do
    field :current_state, :string, default: "created"
    field :name, :string

    field :token, :binary
    field :type, :string

    field :expires_in, :integer, virtual: true
    field :expires_at, :utc_datetime

    field :release_channel, :string, default: "active"

    belongs_to :space, Space

    timestamps(type: :utc_datetime_usec)
  end

  def expires_in_range, do: @expires_in_range

  def types, do: ["lxd", "incus"]

  @doc false
  def changeset(credential, attrs) do
    expires_in_range_values = Enum.map(@expires_in_range, fn r -> r.value end)

    credential
    |> cast(attrs, [:name, :expires_in, :type, :release_channel])
    |> generate_token()
    |> validate_inclusion(:expires_in, expires_in_range_values)
    |> validate_inclusion(:type, types())
    |> maybe_set_expires_at()
    |> validate_required([:token, :type, :name])
    |> validate_inclusion(:release_channel, ReleaseChannel.valid_names())
    |> unique_constraint(:name, name: :space_credentials_space_id_name_index)
  end

  def scope(:active, queryable) do
    from(c in queryable, where: c.current_state == "active")
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
