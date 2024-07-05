defmodule Polar.Repo.Migrations.CreateChecks do
  use Ecto.Migration

  def change do
    create table(:checks) do
      add :slug, :citext, null: false
      add :description, :citext, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:checks, [:slug], unique: true)
  end
end
