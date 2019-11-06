defmodule Timesheets.Sheets.Sheet do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sheets" do
    field :approved, :boolean, default: false
    field :workdate, :date

    belongs_to :user, Timesheets.Users.User
    has_many :logs, Timesheets.Logs.Log
    timestamps()
  end

  @doc false
  def changeset(sheet, attrs) do
    sheet
    |> cast(attrs, [:workdate, :approved, :user_id])
    |> validate_required([:workdate, :approved, :user_id])
  end
end
