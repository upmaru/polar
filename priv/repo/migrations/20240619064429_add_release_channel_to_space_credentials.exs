defmodule Polar.Repo.Migrations.AddReleaseChannelToSpaceCredentials do
  use Ecto.Migration

  def change do
    alter table(:space_credentials) do
      add :release_channel, :string, default: "active"
    end
  end
end
