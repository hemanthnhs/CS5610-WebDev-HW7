defmodule Timesheets.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :serial, primary_key: true
      add :jobname, :string, null: false
      add :desc, :text
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:jobs, [:jobname])
    create index(:jobs, [:user_id])
  end
end
