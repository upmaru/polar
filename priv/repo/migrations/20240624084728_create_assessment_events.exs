defmodule Polar.Repo.Migrations.CreateAssessmentEvents do
  use Ecto.Migration

  def change do
    create table(:assessment_events) do
      add(:name, :citext, null: false)
      add(:domain, :citext, null: false)
      add(:metadata, :map, default: "{}")

      add(
        :assessment_id,
        references(:assessments, on_delete: :restrict),
        null: false
      )

      add(
        :user_id,
        references(:users, on_delete: :restrict),
        null: false
      )

      timestamps(type: :utc_datetime_usec)
    end

    create index(:assessment_events, [:assessment_id])
    create index(:assessment_events, [:user_id])
  end
end
