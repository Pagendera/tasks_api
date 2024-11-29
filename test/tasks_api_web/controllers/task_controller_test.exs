defmodule TasksApiWeb.TaskControllerTest do
  use TasksApiWeb.ConnCase, async: true

  import TasksApiWeb.Auth.Guardian

  alias TasksApi.Repo
  alias TasksApi.Tasks.Task
  alias TasksApi.Accounts.Account

  setup %{conn: conn} do
    conn = authorize_user(conn, "test@example.com", "password123")
    {:ok, conn: conn}
  end

  describe "GET /task_list" do
    test "lists all tasks", %{conn: conn} do
      task1 = %Task{title: "Task 1", description: "Task 1 description"} |> Repo.insert!()
      task2 = %Task{title: "Task 2", description: "Task 2 description"} |> Repo.insert!()

      conn = get(conn, ~p"/api/task_list")
      response = json_response(conn, 200)

      assert length(response["task_list"]) == 2
      assert Enum.any?(response["task_list"], fn t -> t["id"] == task1.id end)
      assert Enum.any?(response["task_list"], fn t -> t["id"] == task2.id end)
    end
  end

  describe "POST /user/take_task" do
    test "successfully takes a task", %{conn: conn} do
      task = %Task{title: "Task 1", description: "Task description"} |> Repo.insert!()

      conn = post(conn, ~p"/api/user/take_task", %{"id" => task.id})
      response = json_response(conn, 200)

      assert response["task"]["id"] == task.id
      assert response["task"]["status"] == "in_work"
      assert response["task"]["account_id"] == conn.assigns.account.id
    end

    test "handles task not existing", %{conn: conn} do
      conn = post(conn, ~p"/api/user/take_task", %{"id" => -1})
      response = json_response(conn, 200)

      assert response["message"] == "Task doesnt exist"
    end
  end

  defp authorize_user(conn, email, hash_password) do

    account = %Account{
      email: email,
      hash_password: hash_password
    } |> Repo.insert!()

    {:ok, token, _} = encode_and_sign(account, %{}, token_type: :access)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
    |> assign(:account, account)
  end
end
