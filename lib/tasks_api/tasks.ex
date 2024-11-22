defmodule TasksApi.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TasksApi.Repo

  alias TasksApi.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks(filters \\ %{}) do
    Task
    |> filter_by_user_id(filters["user_id"])
    |> filter_by_status(filters["status"])
    |> Repo.all()
  end

  def get_tasks_by_user_id(user_id) do
    Repo.all(from t in Task, where: t.user_id == ^user_id)
  end

  def get_tasks_by_status(status) do
    Repo.all(from t in Task, where: t.status == ^status)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task(id) when is_integer(id), do: Repo.get(Task, id)

  def get_task(_id), do: {:error, message: "Wrong type"}

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end


  def take_task(task_id, user, status) do
    update_task(get_task(task_id), %{user_id: user.id, status: status})
  end

  def take_task(task_id, user) do
    update_task(get_task(task_id), %{user_id: user.id, status: "in_work"})
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  defp filter_by_user_id(query, nil), do: query
  defp filter_by_user_id(query, user_id), do: query |> where([t], t.user_id == ^user_id)

  defp filter_by_status(query, nil), do: query
  defp filter_by_status(query, status), do: query |> where([t], t.status == ^status)
end
