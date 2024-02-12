defmodule Polar.Streams.Version do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams.Product
  alias Polar.Streams.Item

  schema "versions" do
    field :serial, :string

    belongs_to :product, Product

    has_many :items, Item

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(version, attrs) do
    version
    |> cast(attrs, [:serial])
    |> validate_required([:serial])
    |> cast_assoc(:items, required: true)
  end
end
