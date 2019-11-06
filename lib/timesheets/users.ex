defmodule Timesheets.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo

  alias Timesheets.Users.User


  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)
    case Argon2.check_pass(user, password) do
      {:ok, user} -> user
      _else       -> nil
    end
  end

end
