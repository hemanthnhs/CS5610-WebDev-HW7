defmodule Timesheets.Jobs.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :jobcode, :string

    belongs_to :user, Timesheets.Users.User
    has_many :logs, Timesheets.Logs.Log
    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:jobcode])
    |> validate_required([:jobcode])
  end
end
