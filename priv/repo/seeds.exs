# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timesheets.Repo.insert!(%Timesheets.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Timesheets.Repo
alias Timesheets.Users.User
alias Timesheets.Jobs.Job

Repo.insert!(%User{name: "manager1", email: "manager1@example.com", password_hash:  Argon2.add_hash("passwordmanager1").password_hash, is_manager: true})
Repo.insert!(%User{name: "manager2", email: "manager2@example.com", password_hash:  Argon2.add_hash("passwordmanager2").password_hash, is_manager: true})
Repo.insert!(%User{name: "manager3", email: "manager3@example.com", password_hash:  Argon2.add_hash("passwordmanager3").password_hash, is_manager: true})
Repo.insert!(%User{name: "manager4", email: "manager4@example.com", password_hash:  Argon2.add_hash("passwordmanager4").password_hash, is_manager: true})
Repo.insert!(%User{name: "worker1", email: "worker1@example.com", password_hash:  Argon2.add_hash("passwordworker1").password_hash, supervisor_id: 1})
Repo.insert!(%User{name: "worker2", email: "worker2@example.com", password_hash:  Argon2.add_hash("passwordworker2").password_hash, supervisor_id: 1})
Repo.insert!(%User{name: "worker3", email: "worker3@example.com", password_hash:  Argon2.add_hash("passwordworker3").password_hash, supervisor_id: 1})
Repo.insert!(%User{name: "worker4", email: "worker4@example.com", password_hash:  Argon2.add_hash("passwordworker4").password_hash, supervisor_id: 1})
Repo.insert!(%User{name: "worker5", email: "worker5@example.com", password_hash:  Argon2.add_hash("passwordworker5").password_hash, supervisor_id: 1})
Repo.insert!(%User{name: "worker6", email: "worker6@example.com", password_hash:  Argon2.add_hash("passwordworker6").password_hash, supervisor_id: 2})
Repo.insert!(%User{name: "worker7", email: "worker7@example.com", password_hash:  Argon2.add_hash("passwordworker7").password_hash, supervisor_id: 2})
Repo.insert!(%User{name: "worker8", email: "worker8@example.com", password_hash:  Argon2.add_hash("passwordworker8").password_hash, supervisor_id: 3})
Repo.insert!(%User{name: "worker9", email: "worker9@example.com", password_hash:  Argon2.add_hash("passwordworker9").password_hash, supervisor_id: 3})
Repo.insert!(%User{name: "worker10", email: "worker10@example.com", password_hash:  Argon2.add_hash("passwordworker10").password_hash, supervisor_id: 4})
Repo.insert!(%Job{jobname: "Job1", desc: "This is job 1", user_id: 1})
Repo.insert!(%Job{jobname: "Job2", desc: "This is job 2", user_id: 1})
Repo.insert!(%Job{jobname: "Job3", desc: "This is job 3", user_id: 1})
Repo.insert!(%Job{jobname: "Job4", desc: "This is job 4", user_id: 2})
Repo.insert!(%Job{jobname: "Job5", desc: "This is job 5", user_id: 2})
Repo.insert!(%Job{jobname: "Job6", desc: "This is job 6", user_id: 3})