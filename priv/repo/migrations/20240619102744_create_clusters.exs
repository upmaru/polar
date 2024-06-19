defmodule Polar.Repo.Migrations.CreateClusters do
  use Ecto.Migration

  def change do
    create table(:clusters) do
      add :name, :citext, null: false
      add :type, :citext, null: false
      add :arch, :citext, null: false
      add :credential, :binary, null: false
      add :current_state, :citext, default: "created"

      timestamps(type: :utc_datetime_usec)
    end
  end
end
