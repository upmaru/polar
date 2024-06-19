defmodule Polar.Machines.Assessment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams
  alias Polar.Machines.Check
  alias Polar.Machines.Cluster
  s

  schema "assessments" do
    field :current_state, :string, default: "created"

    belongs_to :check, Check
    belongs_to :cluster, Cluster

    belongs_to :version, Streams.Version

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(assessment, attrs) do
    assessment
    |> cast(attrs, [:current_state])
    |> validate_required([:current_state])
  end
end
