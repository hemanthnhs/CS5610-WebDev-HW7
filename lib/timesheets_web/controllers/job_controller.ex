defmodule Timesheets2Web.JobController do
  use Timesheets2Web, :controller

  alias Timesheets2.Jobs
  alias Timesheets2.Jobs.Job

  action_fallback Timesheets2Web.FallbackController

  def index(conn, _params) do
    jobs = Jobs.list_jobs()
    render(conn, "index.json", jobs: jobs)
  end
end
