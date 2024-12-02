defmodule TasksApiWeb.AccountController do
  use TasksApiWeb, :controller

  alias TasksApi.Accounts
  alias TasksApi.Accounts.Account
  alias TasksApiWeb.Auth.Guardian

  action_fallback TasksApiWeb.FallbackController

  def create(conn,
    %{"email" => _email,
    "password" => _password,
    "password_confirmation" => _password_confirmation} = account_params
    ) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(account) do
            conn
            |> Plug.Conn.put_session(:account_id, account.id)
            |> put_status(:created)
            |> render(:show_token, account: account, token: token)
    else
      {:error, changeset} -> conn |> put_view(json: TasksApiWeb.ChangesetJSON) |> render(:error, changeset: changeset)
    end
  end

  def create(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid request"})
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
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

  def sign_in(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{error: "Invalid request"})
  end
end
