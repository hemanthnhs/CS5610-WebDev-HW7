defmodule Timesheets2.Repo do
  use Ecto.Repo,
    otp_app: :timesheets2,
    adapter: Ecto.Adapters.Postgres
end
