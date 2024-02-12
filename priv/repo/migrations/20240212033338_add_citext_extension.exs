defmodule Polar.Repo.Migrations.AddCitextExtension do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION citext", "DROP EXTENSION citext"
  end
end
