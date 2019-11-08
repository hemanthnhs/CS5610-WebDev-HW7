defmodule Timesheets2Web.SheetView do
  use Timesheets2Web, :view
  alias Timesheets2Web.SheetView
  alias Timesheets2Web.LogView

  def render("index.json", %{sheets: sheets}) do
    %{data: render_many(sheets, SheetView, "sheet.json")}
  end

  def render("show.json", %{sheet: sheet}) do
    %{data: render_one(sheet, SheetView, "sheet.json")}
  end

  def render("sheet.json", %{sheet: sheet}) do
    %{id: sheet.id,
      workdate: sheet.workdate,
      approved: sheet.approved,
      logs: render_many(sheet.logs, LogView, "log.json"),
      user_name: sheet.user.name
    }
  end
end
