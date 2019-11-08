use Mix.Config

# Configure your database
config :timesheets2, Timesheets2.Repo,
  username: "timesheets2",
  password: "ooVob2faiphe",
  database: "timesheets2_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timesheets2, Timesheets2Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
