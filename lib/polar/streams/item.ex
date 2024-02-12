defmodule Polar.Streams.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :file_type, :string
    field :hash, :string
    field :version_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:file_type, :hash])
    |> validate_required([:file_type, :hash])
  end
end
