defmodule Polar.Repo.Migrations.CreateSpacesToken do
  use Ecto.Migration

  def change do
    create table(:space_credentials) do
      add :current_state, :citext, default: "active", null: false

      add :token, :binary, null: false
      add :expires_at, :utc_datetime
      add :access_count, :integer, default: 0
      add :last_accessed_at, :utc_datetime

      add :space_id, references(:spaces, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_usec)
    end
  end
end
