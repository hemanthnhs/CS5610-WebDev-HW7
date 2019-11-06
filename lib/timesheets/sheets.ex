defmodule Timesheets.Sheets do
  @moduledoc """
  The Sheets context.
  """

  import Ecto.Query, warn: false
  alias Timesheets.Repo
  alias Timesheets.Logs
  alias Timesheets.Sheets.Sheet

  @doc """
  Returns the list of sheets.

  ## Examples

      iex> list_sheets()
      [%Sheet{}, ...]

  """
  def list_sheets do
    Repo.all(Sheet)
  end

  @doc """
  Gets a single sheet.

  Raises `Ecto.NoResultsError` if the Sheet does not exist.

  ## Examples

      iex> get_sheet!(123)
      %Sheet{}

      iex> get_sheet!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sheet!(id), do: Repo.get!(Sheet, id)

  @doc """
  Creates a sheet.

  ## Examples

      iex> create_sheet(%{field: value})
      {:ok, %Sheet{}}

      iex> create_sheet(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sheet(attrs \\ %{}) do
    sheet = %Sheet{}
            |> Sheet.changeset(attrs)
            |> Repo.insert()
    case sheet do
      {:ok, sheet_info} ->
        for work_id <- (1..8) do
          if (attrs["job_id_#{work_id}"] != "" and attrs["hours_#{work_id}"] != "") do
            Logs.create_log(%{sheet_id: sheet_info.id, job_id: attrs["job_id_#{work_id}"], desc: attrs["desc_#{work_id}"], hours: attrs["hours_#{work_id}"]})
          end
        end
        sheet
      {:error, _} ->
        sheet
    end
  end

  @doc """
  Updates a sheet.

  ## Examples

      iex> update_sheet(sheet, %{field: new_value})
      {:ok, %Sheet{}}

      iex> update_sheet(sheet, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sheet(%Sheet{} = sheet, attrs) do
    sheet
    |> Sheet.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Sheet.

  ## Examples

      iex> delete_sheet(sheet)
      {:ok, %Sheet{}}

      iex> delete_sheet(sheet)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sheet(%Sheet{} = sheet) do
    Repo.delete(sheet)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sheet changes.

  ## Examples

      iex> change_sheet(sheet)
      %Ecto.Changeset{source: %Sheet{}}

  """
  def change_sheet(%Sheet{} = sheet) do
    Sheet.changeset(sheet, %{})
  end
end
