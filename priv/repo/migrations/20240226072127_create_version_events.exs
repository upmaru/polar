defmodule Polar.Repo.Migrations.CreateVersionEvents do
  use Ecto.Migration

  def change do
    create table(:version_events) do
      add(:name, :citext, null: false)
      add(:domain, :citext, null: false)
      add(:metadata, :map, default: "{}")

      add(
        :version_id,
        references(:versions, on_delete: :restrict),
        null: false
      )

      add(
        :user_id,
        references(:users, on_delete: :restrict),
        null: false
      )

      timestamps(type: :utc_datetime_usec)
    end

    create index(:version_events, [:version_id])
    create index(:version_events, [:user_id])
  end
end
