defmodule Polar.Repo.Migrations.CreateAssessments do
  use Ecto.Migration

  def change do
    create table(:assessments) do
      add :current_state, :citext, default: "created", null: false

      add :check_id, references(:checks, on_delete: :restrict), null: false
      add :version_id, references(:versions, on_delete: :restrict), null: false
      add :cluster_id, references(:clusters, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime_utc)
    end

    create index(:assessments, [:check_id])
    create index(:assessments, [:version_id])
    create index(:assessments, [:cluster_id])

    create index(:assessments, [:check_id, :version_id], unique: true)
  end
end
