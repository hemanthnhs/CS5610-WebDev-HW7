defmodule TimesheetsWeb.SheetController do
  use TimesheetsWeb, :controller

  alias Timesheets.Sheets
  alias Timesheets.Sheets.Sheet
  alias Timesheets.Logs

  action_fallback TimesheetsWeb.FallbackController

  plug TimesheetsWeb.Plugs.RequireAuth when action in [:create, :index, :show, :approve]

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
    render(conn, "show.json", sheet: sheet)
  end
end
