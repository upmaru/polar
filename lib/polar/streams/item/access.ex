defmodule Polar.Streams.Item.Access do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Streams.Item
  alias Polar.Accounts.Space

  schema "item_accesses" do
    belongs_to :item, Item
    belongs_to :space_credential, Space.Credential

    field :count, :integer, default: 0

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(access, attrs) do
    access
    |> cast(attrs, [])
    |> validate_required([])
  end
end
