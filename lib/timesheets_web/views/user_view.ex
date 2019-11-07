defmodule TimesheetsWeb.UserView do
  use TimesheetsWeb, :view
  alias TimesheetsWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    IO.puts("=======================================")
    IO.inspect(user)
    %{id: user.id,
      email: user.email,
      name: user.name,
      password_hash: user.password_hash,
      is_manager: user.is_manager,
      manager_id: user.supervisor_id
    }
  end
end
