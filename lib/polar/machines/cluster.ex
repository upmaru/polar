defmodule Polar.Machines.Cluster do
  use Ecto.Schema
  import Ecto.Changeset

  alias __MODULE__.Credential
  alias __MODULE__.Transitions
  alias __MODULE__.Event

  use Eventful.Transitable

  Transitions
  |> governs(:current_state, on: Event)

  @valid_attrs ~w(
    name
    type
    arch
    credential_endpoint
    credential_password
    credential_password_confirmation
  )a

  @required_attrs ~w(
    name
    type
    arch
    credential_endpoint
    credential_password
    credential_password_confirmation
  )a

  schema "clusters" do
    field :name, :string
    field :current_state, :string, default: "created"

    field :type, :string, default: "lxd"
    field :arch, :string

    field :credential_endpoint, :string, virtual: true
    field :credential_password, :string, virtual: true
    field :credential_password_confirmation, :string, virtual: true
    field :credential, Polar.Encrypted.Map

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(cluster, attrs) do
    cluster
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
    |> validate_inclusion(:type, ["lxd", "incus"])
    |> validate_inclusion(:arch, ["amd64", "arm64"])
    |> process_credential()
  end

  def update_changeset(cluster, attrs) do
    cluster
    |> cast(attrs, [:credential_endpoint])
    |> maybe_update_credential()
  end

  defp maybe_update_credential(%{data: %{credential: credential}} = changeset) do
    if changeset.valid? do
      endpoint = get_change(changeset, :credential_endpoint)

      credential =
        %Credential{
          endpoint: credential["endpoint"],
          private_key: credential["private_key"],
          certificate: credential["certificate"]
        }
        |> Credential.update!(%{endpoint: "https://#{endpoint}"})

      put_change(changeset, :credential, credential)
    else
      changeset
    end
  end

  defp process_credential(changeset) do
    if changeset.valid? do
      endpoint = get_change(changeset, :credential_endpoint)

      credential =
        Credential.create!(%{
          endpoint: "https://#{endpoint}",
          password: get_change(changeset, :credential_password),
          password_confirmation: get_change(changeset, :credential_password_confirmation)
        })

      put_change(changeset, :credential, credential)
    else
      changeset
    end
  end
end
