defmodule Timesheets.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :desc, :string
    field :hours, :integer
    field :job_id, :id
    field :sheet_id, :id

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:hours, :desc])
    |> validate_required([:hours, :desc])
  end
end
