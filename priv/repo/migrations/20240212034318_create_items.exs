defmodule Polar.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :file_type, :citext, null: false
      add :hash, :citext, null: false
      add :version_id, references(:versions, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:items, [:version_id])
  end
end
