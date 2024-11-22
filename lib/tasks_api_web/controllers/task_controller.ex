defmodule TasksApiWeb.TaskController do
  use TasksApiWeb, :controller

  alias TasksApi.Tasks
  alias TasksApi.Tasks.Task

  action_fallback TasksApiWeb.FallbackController

  def index(conn, params) do
    tasks = Tasks.list_tasks(params)
    render(conn, "index.json", tasks: tasks)
  end
  
  def take_task(conn, %{"id" => task_id, "status" => status}) do
    with {:task_fetch, %Task{} = task} <- {:task_fetch, Tasks.get_task(task_id)},
         {:is_valid_user, true} <- {:is_valid_user, task.user_id == conn.assigns.user.id},
         {:is_valid_status, true} <- {:is_valid_status, is_valid_status(status)} do

      {:ok, task} = Tasks.take_task(task_id, conn.assigns.user, status)

      conn
      |> render(:show, task: task)

    else
      {:task_fetch, nil} -> json(conn, %{message: "Task doesnt exist"})
      {:task_fetch, {:error, message: message}} -> json(conn |> put_status(:bad_request), %{message: message})
      {:is_valid_user, false} -> json(conn |> put_status(:unauthorized), %{message: "Unauthorized"})
      {:is_valid_status, false} -> json(conn, %{message: "Wrong status"})
    end
  end

  def take_task(conn, %{"id" => task_id}) do
    with {:task_fetch, %Task{} = task} <- {:task_fetch, Tasks.get_task(task_id)},
         {:is_task_available, true, _task} <- {:is_task_available, is_task_available?(task), task} do

      {:ok, task} = Tasks.take_task(task_id, conn.assigns.user)

      conn
      |> render(:show, task: task)
    else
      {:task_fetch, nil} -> json(conn, %{message: "Task doesnt exist"})
      {:task_fetch, {:error, message: message}} -> json(conn |> put_status(:bad_request), %{message: message})
      {:is_task_available, false, task} when task.user_id == conn.assigns.user.id -> render(conn, :show, task: task)
      {:is_task_available, false, _task} -> json(conn |> put_status(:unauthorized), %{message: "Unauthorized"})
    end
  end

  defp is_task_available?(task) do
    is_nil(task.user_id)
  end

  defp is_valid_status(status), do: "#{status}" == "completed"
end
