defmodule Polar.Machines.Assessment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams
  alias Polar.Machines.Check
  alias Polar.Machines.Cluster

  alias __MODULE__.Event
  alias __MODULE__.Transitions

  use Eventful.Transitable

  Transitions
  |> governs(:current_state, on: Event)

  @valid_attrs ~w(
    version_id 
    cluster_id
  )a

  @required_attrs ~w(
    version_id
    cluster_id
  )a

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
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
  end
end
