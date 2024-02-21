defmodule Polar.Repo.Migrations.AddUniqueIndexForSpaceCredentials do
  use Ecto.Migration

  def change do
    create index(:space_credentials, [:token], unique: true)
  end
end
