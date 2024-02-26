defmodule Polar.Repo.Migrations.RemoveCDNHostFromSpaces do
  use Ecto.Migration

  def change do
    alter table(:spaces) do
      remove :cdn_host
    end
  end
end
