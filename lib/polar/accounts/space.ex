defmodule Polar.Accounts.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Accounts.User

  schema "spaces" do
    field :name, :string

    belongs_to :owner, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(space, attrs) do
    space
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, name: :spaces_owner_id_name_index)
  end
end
