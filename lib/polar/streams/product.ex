defmodule Polar.Streams.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams.Version

  import Ecto.Query, only: [from: 2]

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

    has_many :active_versions, Version, where: [current_state: "active"]

    timestamps(type: :utc_datetime_usec)
  end

  def key(%__MODULE__{os: os, release: release, arch: arch, variant: variant}) do
    Enum.join([String.downcase(os), release, arch, variant], ":")
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
  end

  def filter(:active, queryable) do
    from(
      p in queryable,
      join: v in assoc(p, :active_versions),
      where: not is_nil(v.product_id)
    )
  end
end
