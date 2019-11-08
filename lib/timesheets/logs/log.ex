defmodule Timesheets2.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :desc, :string
    field :hours, :integer

    belongs_to :job, Timesheets2.Jobs.Job
    belongs_to :sheet, Timesheets2.Sheets.Sheet
    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:hours, :desc, :job_id, :sheet_id])
    |> validate_required([:hours, :job_id, :sheet_id])
  end
end
