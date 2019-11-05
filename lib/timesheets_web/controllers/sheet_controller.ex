defmodule TimesheetsWeb.SheetController do
  use TimesheetsWeb, :controller

  alias Timesheets.Jobs
  alias Timesheets.Sheets
  alias Timesheets.Sheets.Sheet
  alias Timesheets.Logs

  plug :authenticate_user when action in [:index, :new, :create, :show]
  plug :authenticate_manager when action in [:delete, :approve]

  def index(conn, _params) do
    if conn.assigns[:current_user].is_manager do
      sheets = Sheets.list_subordinate_sheets(conn.assigns[:current_user].id)
      render(conn, "index.html", sheets: sheets)
    else
      sheets = Sheets.list_sheets_of_logged(conn.assigns[:current_user].id)
      render(conn, "index.html", sheets: sheets)
    end
  end

  def new(conn, _params) do
    # Attribution : https://stackoverflow.com/questions/36698192/how-to-create-a-select-tag-with-options-and-values-from-a-separate-model-in-the
    jobs = Jobs.list_jobs() |> Enum.map(&{&1.jobname, &1.id})
    changeset = Sheets.change_sheet(%Sheet{})
    render(conn, "new.html", changeset: changeset, jobs: jobs)
  end

  def create(conn, %{"sheet" => sheet_params}) do
    sheet_params = Map.put(sheet_params, "user_id", conn.assigns[:current_user].id)
    case Sheets.create_sheet(sheet_params) do
      {:ok, sheet} ->
        conn
        |> put_flash(:info, "Sheet submitted for Managers Approval.")
        |> redirect(to: Routes.sheet_path(conn, :show, sheet))

      {:error, %Ecto.Changeset{} = changeset} ->
        jobs = Jobs.list_jobs() |> Enum.map(&{&1.jobname, &1.id})
        render(conn, "new.html", changeset: changeset, jobs: jobs)
    end
  end

  def approve(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    Sheets.approve_sheet(sheet)
    conn = put_flash(conn, :info, "Approve Successful")
    redirect(conn, to: Routes.sheet_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    logs = Logs.get_logs(id)
    render(conn, "show.html", sheet: sheet, logs: logs)
  end

  def delete(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    {:ok, _sheet} = Sheets.delete_sheet(sheet)

    conn
    |> put_flash(:info, "Time Sheet disapproved and deleted successfully.")
    |> redirect(to: Routes.sheet_path(conn, :index))
  end

  defp authenticate_user(conn, _params) do
#   Attribution: Plugs from lens notes discussed on friday
#   Reference https://whatdidilearn.info/2018/02/25/phoenix-authentication-and-authorization-using-plugs.html
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:error, "Please sign in and try again.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
      else
        conn
    end
  end

  defp authenticate_manager(conn, _params) do
    if is_nil(conn.assigns.current_user) do
      conn
      |> put_flash(:error, "Please sign in and try again.")
      |> redirect(to: Routes.session_path(conn, :new))
      |> halt()
    else
      if conn.assigns.current_user.is_manager do
        conn
      else
        conn
        |> put_flash(:error, "Action not permitted for user.")
        |> redirect(to: Routes.sheet_path(conn, :index))
        |> halt()
      end
    end
  end
end
