defmodule Polar.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :aliases, {:array, :string}, default: [], null: false
      add :os, :citext, null: false
      add :release, :citext, null: false
      add :release_title, :citext, null: false
      add :arch, :citext, null: false
      add :variant, :citext, null: false
      add :requirements, :map, default: %{}, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:products, [:os, :release, :arch, :variant], unique: true)
  end
end
