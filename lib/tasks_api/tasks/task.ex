defmodule TasksApi.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :status, StatusEnum
    belongs_to :account, TasksApi.Accounts.Account

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status, :account_id])
    |> validate_required([:title, :description])
  end
end
