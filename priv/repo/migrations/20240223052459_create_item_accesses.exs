defmodule Polar.Repo.Migrations.CreateItemAccesses do
  use Ecto.Migration

  def change do
    create table(:item_accesses) do
      add :item_id, references(:items, on_delete: :restrict), null: false
      add :space_credential_id, references(:space_credentials, on_delete: :restrict), null: false
      add :count, :integer, default: 0, null: false

      timestamps(type: :utc_datetime_usec)
    end

    create index(:item_accesses, [:item_id])
    create index(:item_accesses, [:space_credential_id])
  end
end
