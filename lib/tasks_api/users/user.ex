defmodule TasksApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    belongs_to :account, TasksApi.Accounts.Account
    has_many :task, TasksApi.Tasks.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id])
    |> validate_required([:account_id])
  end
end
