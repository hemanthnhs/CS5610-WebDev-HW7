defmodule Timesheets.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :jobcode, :string, null: false, unique: true
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:jobs, [:jobcode])
    create index(:jobs, [:user_id])
  end
end
