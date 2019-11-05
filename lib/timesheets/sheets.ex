defmodule Timesheets.Sheets do
  @moduledoc """
  The Sheets context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo

  alias Timesheets.Sheets.Sheet
  alias Timesheets.Logs
  alias Timesheets.Users.User

  def list_subordinate_sheets(manager_id) do
    subordinates = Repo.all(from(u in User, select: u.id, where: u.supervisor_id == ^manager_id))
    Repo.all(from(s in Sheet, where: s.user_id in ^subordinates, order_by: {:desc, s.inserted_at},preload: [:user]))
  end

  def list_sheets_of_logged(worker_id) do
    #    Attribution and Reference from https://elixirforum.com/t/what-is-the-correct-way-to-use-ecto-query-that-allow-items-to-be-displayed-in-templates/7313
    #    Attribution and Reference from https://elixirforum.com/t/nested-preload-from-the-doc-makes-me-confused/11991/5
    Repo.all(from(s in Sheet, where: s.user_id == ^worker_id, order_by: {:desc, s.inserted_at}))
  end

  def get_sheet!(id) do
    Repo.get!(Sheet, id) |> Repo.preload([:user, :logs])
  end

  def approve_sheet(%Sheet{} = sheet) do
    sheet
    |> Sheet.changeset(%{approved: true})
    |> Repo.update()
  end

  def create_sheet(attrs \\ %{}) do
    sheet = %Sheet{}
    |> Sheet.changeset(attrs)
    |> Repo.insert()
    case sheet do
    {:ok, sheet_info} ->
      for work_id <- (1..8) do
        if (attrs["job_id_#{work_id}"] != "" and attrs["hours_#{work_id}"] != "") do
          Logs.create_log(%{sheet_id: sheet_info.id, job_id: attrs["job_id_#{work_id}"], desc: attrs["desc_#{work_id}"], hours: attrs["hours_#{work_id}"]})
        end
      end
      sheet
    {:error, _} ->
      sheet
    end
  end

  def change_sheet(%Sheet{} = sheet) do
    Sheet.changeset(sheet, %{})
  end

  def delete_sheet(%Sheet{} = sheet) do
    Repo.delete(sheet)
  end
end
