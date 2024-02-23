defmodule Polar.Repo.Migrations.AddUniqueIndexForItemAcceses do
  use Ecto.Migration

  def change do
    create index(:item_accesses, [:item_id, :space_credential_id], unique: true)
  end
end
