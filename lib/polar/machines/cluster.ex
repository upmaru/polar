defmodule Polar.Machines.Cluster do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(
    name
    type
    arch
    credential
  )a

  schema "clusters" do
    field :name, :string
    field :current_state, :string, default: "created"

    field :type, :string
    field :arch, :string

    field :credential, Polar.Encrypted.Map

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(cluster, attrs) do
    cluster
    |> cast(attrs, @valid_attrs)
    |> validate_required(@valid_attrs)
  end
end
