defmodule TasksApiWeb.TaskJSON do
  alias TasksApi.Tasks.Task

  def index(%{tasks: tasks}) do
    %{message: "OK", task_list: for(task <- tasks, do: data(task))}
  end

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
      account_id: task.account_id
    }
  end
end
