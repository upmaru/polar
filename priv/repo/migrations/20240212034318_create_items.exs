defmodule Polar.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :citext, null: false
      add :file_type, :citext, null: false
      add :hash, :citext, null: false
      add :size, :integer, null: false
      add :path, :citext, null: false

      add :is_metadata, :boolean, default: false

      add :combined_hashes, {:array, :map}, default: [], null: false

      add :version_id, references(:versions, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:items, [:version_id])
  end
end
