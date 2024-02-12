defmodule Polar.Streams.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(
    aliases
    arch
    os
    release
    release_title
    requirements
    variant
  )a

  @required_attrs ~w(
    aliases
    arch
    os
    release
    release_title
    variant
  )a

  schema "products" do
    field :aliases, {:array, :string}
    field :arch, :string
    field :os, :string
    field :release, :string
    field :release_title, :string
    field :requirements, :map, default: %{}
    field :variant, :string, default: "default"

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
  end
end
