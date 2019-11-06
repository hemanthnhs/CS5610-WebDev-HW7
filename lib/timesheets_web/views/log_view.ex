defmodule TimesheetsWeb.LogView do
  use TimesheetsWeb, :view
  alias TimesheetsWeb.LogView

  def render("index.json", %{logs: logs}) do
    %{data: render_many(logs, LogView, "log.json")}
  end

  def render("show.json", %{log: log}) do
    %{data: render_one(log, LogView, "log.json")}
  end

  def render("log.json", %{log: log}) do
    %{id: log.id,
      hours: log.hours,
      desc: log.desc}
  end
end