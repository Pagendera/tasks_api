defmodule TasksApiWeb.TaskController do
  use TasksApiWeb, :controller

  alias TasksApi.Tasks
  alias TasksApi.Tasks.Task

  action_fallback TasksApiWeb.FallbackController

  def index(conn, params) do
    tasks = Tasks.list_tasks(params)
    render(conn, "index.json", tasks: tasks)
  end

  def create(conn, %{"title" => _title, "description" => _description} = task_params) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> render(:show, task: task)
    else
      {:error, changeset} -> conn |> put_view(json: TasksApiWeb.ChangesetJSON) |> render(:error, changeset: changeset)
    end
  end

  def take_task(conn, %{"id" => task_id, "status" => _status} = attrs) do
    with {:task_fetch, %Task{} = task} <- {:task_fetch, Tasks.find_task(task_id, conn.assigns.account.id)},
         {:ok, task} <- Tasks.update_task(task, attrs) do

      conn
      |> render(:show, task: task)

    else
      {:task_fetch, nil} -> json(conn, %{message: "Unauthorized"})
      {:task_fetch, {:error, message: message}} -> json(conn |> put_status(:bad_request), %{message: message})
      {:error, message: message} -> json(conn |> put_status(:bad_request), %{message: message})
    end
  end

  def take_task(conn, %{"id" => task_id} = attrs) do
    with {:task_fetch, %Task{} = task} <- {:task_fetch, Tasks.find_available_task(task_id, conn.assigns.account.id)} do

      {:ok, task} = Tasks.update_task(task, attrs |> Map.merge(%{"account_id" => conn.assigns.account.id, "status" => "in_work"}))

      conn
      |> render(:show, task: task)
    else
      {:task_fetch, nil} -> json(conn, %{message: "Unauthorized"})
      {:task_fetch, {:error, message: message}} -> json(conn |> put_status(:bad_request), %{message: message})
    end
  end
end
