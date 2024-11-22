defmodule TasksApi.TasksTest do
  use TasksApi.DataCase, async: true

  alias TasksApi.Tasks
  alias TasksApi.Tasks.Task
  alias TasksApi.Users.User
  alias TasksApi.Accounts.Account

  describe "list_tasks/1" do
    test "returns all tasks without filters" do
      task1 = insert_task()
      task2 = insert_task()

      tasks = Tasks.list_tasks(%{})

      assert length(tasks) == 2
      assert Enum.any?(tasks, &(&1.id == task1.id))
      assert Enum.any?(tasks, &(&1.id == task2.id))
    end

    test "filters tasks by user_id" do
      user = insert_user()
      task1 = insert_task(%{user_id: user.id})
      insert_task()

      tasks = Tasks.list_tasks(%{"user_id" => user.id})

      assert length(tasks) == 1
      assert hd(tasks).id == task1.id
    end

    test "filters tasks by status" do
      task1 = insert_task(%{status: "in_work"})
      insert_task(%{status: "completed"})

      tasks = Tasks.list_tasks(%{"status" => "in_work"})

      assert length(tasks) == 1
      assert hd(tasks).id == task1.id
    end

    test "filters tasks by both user_id and status" do
      user = insert_user()
      task1 = insert_task(%{user_id: user.id, status: "in_work"})
      insert_task(%{user_id: user.id, status: "completed"})
      insert_task(%{status: "in_work"})

      tasks = Tasks.list_tasks(%{"user_id" => user.id, "status" => "in_work"})

      assert length(tasks) == 1
      assert hd(tasks).id == task1.id
    end
  end

  describe "get_task/1" do
    test "returns the task with the given id" do
      task = insert_task()
      fetched_task = Tasks.get_task(task.id)

      assert fetched_task.id == task.id
    end

    test "returns an error for invalid id type" do
      assert {:error, message: "Wrong type"} = Tasks.get_task("invalid")
    end
  end

  describe "create_task/1" do
    test "creates a task with valid data" do
      valid_attrs = %{title: "Test Task", description: "Task description", status: "in_work"}
      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)

      assert task.title == "Test Task"
      assert task.description == "Task description"
      assert task.status == "in_work"
    end

    test "returns error changeset with invalid data" do
      invalid_attrs = %{title: nil, description: nil}
      assert {:error, changeset} = Tasks.create_task(invalid_attrs)

      refute changeset.valid?
      assert %{title: ["can't be blank"], description: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "update_task/2" do
    test "updates a task with valid data" do
      task = insert_task()
      update_attrs = %{status: "completed"}

      assert {:ok, %Task{} = updated_task} = Tasks.update_task(task, update_attrs)
      assert updated_task.status == "completed"
    end
  end

  describe "take_task/2 and take_task/3" do
    test "assigns a task to a user with default status 'in_work'" do
      task = insert_task()
      user = insert_user()

      assert {:ok, %Task{} = updated_task} = Tasks.take_task(task.id, user)
      assert updated_task.user_id == user.id
      assert updated_task.status == "in_work"
    end

    test "assigns a task to a user with custom status" do
      task = insert_task()
      user = insert_user()

      assert {:ok, %Task{} = updated_task} = Tasks.take_task(task.id, user, "completed")
      assert updated_task.user_id == user.id
      assert updated_task.status == "completed"
    end
  end

  defp insert_task(attrs \\ %{}) do
    default_attrs = %{title: "Default Task", description: "Default description"}
    {:ok, task} = Tasks.create_task(Map.merge(default_attrs, attrs))
    task
  end

  defp insert_user(attrs \\ %{}) do
    account = insert_account()

    attrs = Map.put_new(attrs, :account_id, account.id)

    %User{}
    |> Ecto.Changeset.cast(attrs, [:account_id])
    |> Ecto.Changeset.validate_required([:account_id])
    |> Ecto.Changeset.foreign_key_constraint(:account_id)
    |> TasksApi.Repo.insert!()
  end

  defp insert_account() do
    default_attrs = %{email: "Test Account", hash_password: "password"}

    %Account{}
    |> Ecto.Changeset.cast(default_attrs, [:email, :hash_password])
    |> Ecto.Changeset.validate_required([:email, :hash_password])
    |> TasksApi.Repo.insert!()
  end
end
