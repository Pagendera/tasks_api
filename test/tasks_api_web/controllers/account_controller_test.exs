defmodule TasksApiWeb.AccountControllerTest do
  use TasksApiWeb.ConnCase, async: true

  alias TasksApi.Accounts

  describe "POST /api/accounts/register" do
    test "creates account and user, then returns a token", %{conn: conn} do
      account_params = %{
        "email" => "test@example.com",
        "hash_password" => "password123"
      }

      conn = post(conn, ~p"/api/accounts/register", account: account_params)

      assert Map.has_key?(json_response(conn, 201), "token")
    end
  end

  describe "POST /api/accounts/sign_in" do
    setup do
      {:ok, account} = Accounts.create_account(%{"email" => "test@example.com", "hash_password" => "password123"})
      %{account: account}
    end

    test "signs in with valid credentials", %{conn: conn, account: account} do
      conn = post(conn, ~p"/api/accounts/sign_in", %{
        "email" => account.email,
        "hash_password" => "password123"
      })

      assert Map.has_key?(json_response(conn, 200), "token")
    end

    test "returns unauthorized for invalid credentials", %{conn: conn} do
      conn = post(conn, ~p"/api/accounts/sign_in", %{
        "email" => "invalid@example.com",
        "hash_password" => "wrongpassword"
      })

      assert json_response(conn, 401)["error"] == "Invalid credentials"
    end
  end
end