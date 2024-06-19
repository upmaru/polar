defmodule Polar.Machines.Cluster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clusters" do
    field :name, :string
    field :current_state, :string, default: "created"

    field :type, :string
    field :architecture, :string

    field :credential, Polar.Encrypted.Map

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cluster, attrs) do
    cluster
    |> cast(attrs, [:name, :type, :architecture, :current_state, :credential])
    |> validate_required([:name, :type, :architecture, :current_state, :credential])
  end
end
