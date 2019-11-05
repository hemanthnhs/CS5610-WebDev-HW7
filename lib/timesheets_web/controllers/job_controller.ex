defmodule TimesheetsWeb.JobController do
  use TimesheetsWeb, :controller

  alias Timesheets.Jobs
  alias Timesheets.Jobs.Job

  plug :authenticate_manager when action in [:new, :index, :create, :show, :edit, :update]

  def index(conn, _params) do
    jobs = Jobs.list_jobs(conn.assigns[:current_user].id)
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, _params) do
    changeset = Jobs.change_job(%Job{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"job" => job_params}) do
    job_params = Map.put(job_params, "user_id", conn.assigns[:current_user].id)
    case Jobs.create_job(job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job created successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    render(conn, "show.html", job: job)
  end

  def edit(conn, %{"id" => id}) do
    job = Jobs.get_job!(id)
    changeset = Jobs.change_job(job)
    render(conn, "edit.html", job: job, changeset: changeset)
  end

  def update(conn, %{"id" => id, "job" => job_params}) do
    job = Jobs.get_job!(id)

    case Jobs.update_job(job, job_params) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Job updated successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", job: job, changeset: changeset)
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
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
      end
    end
  end

end
