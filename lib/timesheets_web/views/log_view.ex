defmodule Timesheets2Web.LogView do
  use Timesheets2Web, :view
  alias Timesheets2Web.LogView

  def render("index.json", %{logs: logs}) do
    %{data: render_many(logs, LogView, "log.json")}
  end

  def render("show.json", %{log: log}) do
    %{data: render_one(log, LogView, "log.json")}
  end

  def render("log.json", %{log: log}) do
    %{jobcode: log.job.jobcode,
      hours: log.hours,
      desc: log.desc}
  end
end
