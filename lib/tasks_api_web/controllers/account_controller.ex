defmodule TasksApiWeb.AccountController do
  use TasksApiWeb, :controller

  alias TasksApi.Accounts
  alias TasksApi.Accounts.Account
  alias TasksApi.Users
  alias TasksApi.Users.User
  alias TasksApiWeb.Auth.Guardian

  action_fallback TasksApiWeb.FallbackController

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(account) do
      conn
      |> Plug.Conn.put_session(:account_id, account.id)
      |> put_status(:created)
      |> render(:show_token, account: account, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "hash_password" => hash_password}) do
    case Guardian.authenticate(email, hash_password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render(:show_token, account: account, token: token)

      {:error, _reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end
end
