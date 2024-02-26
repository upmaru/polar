defmodule Polar.Streams.Version do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams.Product
  alias Polar.Streams.Item

  alias __MODULE__.Transitions
  alias __MODULE__.Event

  use Eventful.Transitable

  Transitions
  |> governs(:current_state, on: Event)

  import Ecto.Query, only: [from: 2]

  schema "versions" do
    field :current_state, :string, default: "active"
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

  def latest_version_by_product(count \\ 1) do
    ranking_query =
      from(
        i in __MODULE__,
        select: %{
          id: i.id,
          row_number: over(row_number(), :products_partition)
        },
        windows: [
          products_partition: [
            partition_by: :product_id,
            order_by: [desc: :inserted_at]
          ]
        ]
      )

    from(
      i in __MODULE__,
      join: r in subquery(ranking_query),
      on: i.id == r.id and r.row_number <= ^count
    )
  end
end
