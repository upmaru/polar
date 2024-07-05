defmodule Polar.Repo.Migrations.CreateClusterEvents do
  use Ecto.Migration

  def change do
    create table(:cluster_events) do
      add(:name, :citext, null: false)
      add(:domain, :citext, null: false)
      add(:metadata, :map, default: "{}")

      add(
        :cluster_id,
        references(:clusters, on_delete: :restrict),
        null: false
      )

      add(
        :user_id,
        references(:users, on_delete: :restrict),
        null: false
      )

      timestamps(type: :utc_datetime_usec)
    end

    create index(:cluster_events, [:cluster_id])
    create index(:cluster_events, [:user_id])
  end
end
