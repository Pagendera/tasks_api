defmodule TasksApiWeb.TaskJSON do
  alias TasksApi.Tasks.Task

  @doc """
  Renders a list of tasks.
  """
  def index(%{tasks: tasks}) do
    %{message: "OK", task_list: for(task <- tasks, do: data(task))}
  end

  @doc """
  Renders a single task.
  """
  def show(%{task: task}) do
    %{
      message: "OK",
      task: data(task)
    }
  end
  
  defp data(%Task{} = task) do
    %{
      id: task.id,
      title: task.title,
      description: task.description,
      status: task.status,
      user_id: task.user_id
    }
  end
end
