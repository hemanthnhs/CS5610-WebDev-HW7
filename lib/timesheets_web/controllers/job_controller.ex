defmodule TimesheetsWeb.JobController do
  use TimesheetsWeb, :controller

  alias Timesheets.Jobs
  alias Timesheets.Jobs.Job

  action_fallback TimesheetsWeb.FallbackController

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end
end
