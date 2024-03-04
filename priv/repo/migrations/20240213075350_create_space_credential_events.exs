defmodule Polar.Repo.Migrations.CreateSpaceCredentialEvents do
  use Ecto.Migration

  def change do
    create table(:space_credential_events) do
      add(:name, :citext, null: false)
      add(:domain, :citext, null: false)
      add(:metadata, :map, default: "{}")

      add(
        :space_credential_id,
        references(:space_credentials, on_delete: :restrict),
        null: false
      )

      add(
        :user_id,
        references(:users, on_delete: :restrict),
        null: false
      )

      timestamps(type: :utc_datetime_usec)
    end

    create index(:space_credential_events, [:space_credential_id])
    create index(:space_credential_events, [:user_id])
  end
end
