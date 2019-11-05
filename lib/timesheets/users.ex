defmodule Timesheets.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo
  alias Timesheets.Users.User

  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def authenticate(email, pass) do
    user = Repo.get_by(User, email: email)
    case Argon2.check_pass(user, pass) do
      {:ok, user} -> user
      _ -> nil
    end
  end
end
