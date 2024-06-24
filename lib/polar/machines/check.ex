defmodule Polar.Machines.Check do
  use Ecto.Schema
  import Ecto.Changeset

  schema "checks" do
    field :name, :string, virtual: true

    field :slug, :string
    field :description, :string

    timestamps(type: :utc_datetime_usec)
  end

  @doc false
  def changeset(check, attrs) do
    check
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
    |> generate_slug()
  end

  defp generate_slug(changeset) do
    if name = get_change(changeset, :name) do
      put_change(changeset, :slug, Slug.slugify(name))
    else
      changeset
    end
  end
end
