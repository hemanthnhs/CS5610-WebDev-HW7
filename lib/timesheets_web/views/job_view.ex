defmodule Timesheets2Web.JobView do
  use Timesheets2Web, :view
  alias Timesheets2Web.JobView

  def render("index.json", %{jobs: jobs}) do
    %{data: render_many(jobs, JobView, "job.json")}
  end

  def render("show.json", %{job: job}) do
    %{data: render_one(job, JobView, "job.json")}
  end

  def render("job.json", %{job: job}) do
    %{
      id: job.id,
      jobcode: job.jobcode,
      }
  end
end
