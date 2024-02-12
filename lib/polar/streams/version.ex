defmodule Polar.Streams.Version do
  use Ecto.Schema
  import Ecto.Changeset

  schema "versions" do
    field :serial, :string
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(version, attrs) do
    version
    |> cast(attrs, [:serial])
    |> validate_required([:serial])
  end
end
