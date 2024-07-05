defmodule Polar.Repo.Migrations.AddInstanceTypeToAssessments do
  use Ecto.Migration

  def change do
    alter table(:assessments) do
      add :instance_type, :string, null: false
    end

    drop index(:assessments, [:check_id, :version_id], unique: true)
    create index(:assessments, [:check_id, :version_id, :instance_type], unique: true)
  end
end
