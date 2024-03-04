defmodule Polar.Repo.Migrations.CreateSpacesToken do
  use Ecto.Migration

  def change do
    create table(:space_credentials) do
      add :current_state, :citext, default: "created", null: false
      add :name, :citext, null: false
      add :type, :citext, null: false

      add :token, :binary, null: false
      add :expires_at, :utc_datetime

      add :space_id, references(:spaces, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:space_credentials, [:name], unique: true)
  end
end
