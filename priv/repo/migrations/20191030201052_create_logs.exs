defmodule Timesheets.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :hours, :integer, null: false
      add :desc, :text
      add :job_id, references(:jobs, on_delete: :nothing), null: false
      add :sheet_id, references(:sheets, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:logs, [:job_id])
    create index(:logs, [:sheet_id])
  end
end
