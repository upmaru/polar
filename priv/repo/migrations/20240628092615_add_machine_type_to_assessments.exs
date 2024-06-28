defmodule Polar.Repo.Migrations.AddMachineTypeToAssessments do
  use Ecto.Migration

  def change do
    alter table(:assessments) do
      add :machine_type, :string, null: false
    end

    drop index(:assessments, [:check_id, :version_id], unique: true)
    create index(:assessments, [:check_id, :version_id, :machine_type], unique: true)
  end
end
