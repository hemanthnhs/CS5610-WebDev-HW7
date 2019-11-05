defmodule Timesheets.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo

  alias Timesheets.Logs.Log
  @doc """
  Creates a log.
  ## Examples
      iex> create_log(%{field: value})
      {:ok, %Log{}}
      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  def get_logs(id) do
    Repo.all(from(l in Log, where: l.sheet_id == ^id,preload: [:job]))
  end
end