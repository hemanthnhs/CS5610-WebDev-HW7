defmodule Timesheets.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo

  alias Timesheets.Logs.Log

  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  def get_logs(id) do
    Repo.all(from(l in Log, where: l.sheet_id == ^id,preload: [:job]))
  end
end
