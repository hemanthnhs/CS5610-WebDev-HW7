defmodule Timesheets.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :is_manager, :boolean, default: false
    field :name, :string
    field :password_hash, :string
    field :supervisor_id, :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password_hash, :is_manager])
    |> validate_required([:email, :name, :password_hash, :is_manager])
  end
end
