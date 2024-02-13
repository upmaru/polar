defmodule Polar.Repo.Migrations.CreateSpaces do
  use Ecto.Migration

  def change do
    create table(:spaces) do
      add :name, :citext, null: false
      add :cdn_host, :citext

      add :owner_id, references(:users, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:spaces, [:owner_id])
  end
end
