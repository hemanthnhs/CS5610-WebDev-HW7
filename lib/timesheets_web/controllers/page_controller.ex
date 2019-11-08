defmodule Timesheets2Web.PageController do
  use Timesheets2Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
