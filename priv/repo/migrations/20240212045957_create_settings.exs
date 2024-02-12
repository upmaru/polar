defmodule Polar.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :key, :citext, null: false
      add :value, :map, default: %{}, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:settings, [:key], unique: true)
  end
end
