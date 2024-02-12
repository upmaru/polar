defmodule Polar.Repo.Migrations.CreateVersions do
  use Ecto.Migration

  def change do
    create table(:versions) do
      add :current_state, :citext, null: false, default: "active"
      add :serial, :citext, null: false
      add :product_id, references(:products, on_delete: :restrict), null: false

      add :combined, :map, default: %{}, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:versions, [:product_id])
    create index(:versions, [:product_id, :serial], unique: true)
  end
end
