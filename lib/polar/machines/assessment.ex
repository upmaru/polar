defmodule Polar.Machines.Assessment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams
  alias Polar.Machines.Check
  alias Polar.Machines.Cluster

  schema "assessments" do
    field :current_state, :string, default: "created"

    field :check_slug, :string, virtual: true

    belongs_to :check, Check
    belongs_to :cluster, Cluster

    belongs_to :version, Streams.Version

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(assessment, attrs) do
    assessment
    |> cast(attrs, [:cluster_id, :check_slug])
    |> validate_required([:cluster_id, :check_slug])
  end
end
