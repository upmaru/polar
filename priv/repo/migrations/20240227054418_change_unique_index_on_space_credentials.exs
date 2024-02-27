defmodule Polar.Repo.Migrations.ChangeUniqueIndexOnSpaceCredentials do
  use Ecto.Migration

  def change do
    drop index(:space_credentials, [:name], unique: true)
    create index(:space_credentials, [:space_id, :name], unique: true)
  end
end
