defmodule Timesheets.Repo.Migrations.CreateSheets do
  use Ecto.Migration

  def change do
    create table(:sheets, primary_key: false) do
      add :id, :serial, primary_key: true
      add :date, :date, null: false
      add :approved, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:sheets, [:user_id])
  end
end
