defmodule Polar.Streams.Item.CombinedHash do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :name, :string
    field :hash, :string
  end

  def changeset(combined_hash, attrs) do
    combined_hash
    |> cast(attrs, [:name, :hash])
    |> validate_required([:name, :hash])
  end
end
