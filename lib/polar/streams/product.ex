defmodule Polar.Streams.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :aliases, {:array, :string}
    field :arch, :string
    field :os, :string
    field :release, :string
    field :release_title, :string
    field :requirements, :map
    field :variant, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:aliases, :os, :release, :release_title, :arch, :variant, :requirements])
    |> validate_required([:aliases, :os, :release, :release_title, :arch, :variant])
  end
end
