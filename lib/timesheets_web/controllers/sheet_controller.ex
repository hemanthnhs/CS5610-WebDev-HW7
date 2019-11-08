defmodule Timesheets2Web.SheetController do
  use Timesheets2Web, :controller

  alias Timesheets2.Sheets
  alias Timesheets2.Sheets.Sheet
  alias Timesheets2.Logs
  alias Timesheets2Web.SheetChannel

  action_fallback Timesheets2Web.FallbackController

  plug Timesheets2Web.Plugs.RequireAuth when action in [:create, :index, :show, :approve]

  def index(conn, _params) do
    if conn.assigns[:current_user].is_manager do
      sheets = Sheets.list_subordinate_sheets(conn.assigns[:current_user].id)
      render(conn, "index.json", sheets: sheets)
    else
      sheets = Sheets.list_sheets_of_logged(conn.assigns[:current_user].id)
      render(conn, "index.json", sheets: sheets)
    end
  end

  def create(conn, %{"sheet" => sheet_params}) do
    with {:ok, %Sheet{} = sheet} <- Sheets.create_sheet(sheet_params) do
      conn = conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.sheet_path(conn, :show, sheet))
      sheet = Sheets.get_sheet!(sheet.id)
      totalhours = Sheets.get_totalhours(sheet.id)
      if(totalhours < 8) do
        Timesheets2Web.SheetChannel.broadcast_msg(%{"manager_id" => conn.assigns[:current_user].supervisor_id, "user_name" => conn.assigns[:current_user].name, "workdate" => sheet.workdate, "sheet_id" => sheet.id})
      end
      Timesheets2Web.SheetChannel.broadcast_sheet(%{"manager_id" => conn.assigns[:current_user].supervisor_id})
      render(conn, "show.json", sheet: sheet)
    end

  end

  def show(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    render(conn, "show.json", sheet: sheet)
  end

  def approve(conn, %{"id" => id}) do
    sheet = Sheets.get_sheet!(id)
    Sheets.approve_sheet(sheet)
    sheet = Sheets.get_sheet!(id)
    Timesheets2Web.SheetChannel.broadcast_approve(%{"worker_id" => sheet.user_id})
    render(conn, "show.json", sheet: sheet)
  end
end
