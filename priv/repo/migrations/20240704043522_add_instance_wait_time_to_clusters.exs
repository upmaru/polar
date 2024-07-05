defmodule Polar.Repo.Migrations.AddInstanceWaitTimeToClusters do
  use Ecto.Migration

  def change do
    alter table(:clusters) do
      add :instance_wait_times, {:array, :map}, default: []
    end
  end
end
