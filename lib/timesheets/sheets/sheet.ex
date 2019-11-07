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
    |> validate_change(:workdate, &validate_pastdate/2)
    |> validate_hours(attrs)
  end

  def validate_hours(changeset, attrs) do
      if(get_change(changeset, :approved)) do
        changeset
      else
      # https://stackoverflow.com/questions/33492121/how-to-do-reduce-with-index-in-elixir
      {_, total_hours} = 1..8
                         |> Enum.reduce({1,0}, fn(_num,{index,current_result}) ->
        if (attrs["job_id_#{index}"] != "" and attrs["hours_#{index}"] != "" and attrs["job_id_#{index}"] != nil and attrs["hours_#{index}"] != nil) do
          {hours, _} = Integer.parse(attrs["hours_#{index}"])
          {index+1,current_result + hours}
        else
          {index+1,current_result}
        end
      end)
      if(total_hours > 0) do
        if(total_hours <= 8) do
          changeset
        else
          Ecto.Changeset.add_error(changeset, :total_hours, "Total hours exceeded 8. Please check and submit.")
        end
      else
        Ecto.Changeset.add_error(changeset, :total_hours, "Minimum of 1 hours should be logged.")
      end
      end
  end

  def validate_pastdate(_, date) do
    #    Attribution for past date validation
    #    https://elixirforum.com/t/ecto-fields-validations/6081
    Date.compare(date, Date.utc_today())
    |> get_error
  end

  defp get_error(comparison) when comparison == :gt, do: [ date: "Please select a work date in the past" ]
  defp get_error(_), do: []

end
