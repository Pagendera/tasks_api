defmodule TasksApi.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TasksApi.Repo

  alias TasksApi.Tasks.Task

  def list_tasks(filters \\ %{}) do
    Task
    |> filter_by_account_id(filters["account_id"])
    |> filter_by_status(filters["status"])
    |> Repo.all()
  end

  def get_tasks_by_account_id(account_id) do
    Repo.all(from t in Task, where: t.account_id == ^account_id)
  end

  def get_tasks_by_status(status) do
    Repo.all(from t in Task, where: t.status == ^status)
  end

  def get_task(id) when is_integer(id), do: Repo.get(Task, id)

  def get_task(_id), do: {:error, message: "Wrong type"}

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  defp filter_by_account_id(query, nil), do: query
  defp filter_by_account_id(query, account_id), do: query |> where([t], t.account_id == ^account_id)

  defp filter_by_status(query, nil), do: query
  defp filter_by_status(query, status), do: query |> where([t], t.status == ^status)
end
