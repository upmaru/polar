defmodule Polar.Accounts.Space do
  use Ecto.Schema
  import Ecto.Changeset

  alias Polar.Accounts.User

  schema "spaces" do
    field :name, :string
    field :cdn_host, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(space, attrs) do
    space
    |> cast(attrs, [:name, :cdn_host])
    |> validate_required([:name, :cdn_host])
  end
end
