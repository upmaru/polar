defmodule Polar.Streams.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams.Version

  @valid_attrs ~w(
    name
    file_type
    hash
    is_metadata
    size
    path
  )a

  @required_attrs ~w(
    name
    file_type
    hash
    size
    path
  )a

  schema "items" do
    field :name, :string
    field :file_type, :string
    field :hash, :string

    field :size, :integer
    field :path, :string

    field :is_metadata, :boolean, default: false

    belongs_to :version, Version

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, @valid_attrs)
    |> validate_required(@required_attrs)
  end
end
