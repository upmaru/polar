defmodule Polar.Globals.Basic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false

  embedded_schema do
    field :enable_registration, :boolean, default: true
    field :versions_per_product, :integer, default: 1
  end

  def changeset(basic, attrs \\ %{}) do
    basic
    |> cast(attrs, [:enable_registration, :versions_per_product])
    |> validate_required([:enable_registration, :versions_per_product])
    |> validate_number(:versions_per_product, less_than_or_equal_to: 3)
  end

  def parse(value) do
    %__MODULE__{}
    |> changeset(value)
    |> apply_action!(:insert)
  end
end
