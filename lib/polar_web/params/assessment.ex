defmodule PolarWeb.Params.Assessment do
  use Ecto.Schema
  import Ecto.Changeset

  @required_attrs ~w(
    check_id 
    cluster_id 
    instance_type
  )a

  @primary_key false
  embedded_schema do
    field :check_id, :integer
    field :cluster_id, :integer
    field :instance_type, :string
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action(:insert)
  end

  def changeset(assessment, params) do
    assessment
    |> cast(params, @required_attrs)
    |> validate_required(@required_attrs)
  end
end
