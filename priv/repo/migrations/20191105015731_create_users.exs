defmodule Timesheets.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false, unique: true
      add :name, :string, null: false
      add :password_hash, :string, null: false
      add :is_manager, :boolean, default: false, null: false
      add :supervisor_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:users, [:supervisor_id])
  end
end
