defmodule TimesheetsWeb.SheetView do
  use TimesheetsWeb, :view
  alias TimesheetsWeb.SheetView

  def render("index.json", %{sheets: sheets}) do
    %{data: render_many(sheets, SheetView, "sheet.json")}
  end

  def render("show.json", %{sheet: sheet}) do
    %{data: render_one(sheet, SheetView, "sheet.json")}
  end

  def render("sheet.json", %{sheet: sheet}) do
    %{id: sheet.id,
      workdate: sheet.workdate,
      approved: sheet.approved}
  end
end
