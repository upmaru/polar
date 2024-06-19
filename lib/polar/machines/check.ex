defmodule Polar.Machines.Check do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checks" do
    field :slug, :string
    field :description, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(check, attrs) do
    check
    |> cast(attrs, [:slug, :description])
    |> validate_required([:slug, :description])
  end
end
