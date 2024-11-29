defmodule TasksApiWeb.AccountController do
  use TasksApiWeb, :controller

  alias TasksApi.Accounts
  alias TasksApi.Accounts.Account
  alias TasksApiWeb.Auth.Guardian

  action_fallback TasksApiWeb.FallbackController

  def create(conn,
    %{"email" => _email,
    "password" => password,
    "password_confirm" => password_confirm} = account_params
    ) do
    with {:is_password_confirmed, true} <- {:is_password_confirmed, String.equivalent?(password, password_confirm)},
         {:is_password_valid, true} <- {:is_password_valid, String.length(password) >= 8},
         {:ok, %Account{} = account} <- Accounts.create_account(account_params |> Map.merge(%{"hash_password" => Bcrypt.hash_pwd_salt(password)})),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(account) do
            conn
            |> Plug.Conn.put_session(:account_id, account.id)
            |> put_status(:created)
            |> render(:show_token, account: account, token: token)
    else
      {:is_password_confirmed, false} -> json(conn, %{message: "Passwords don't match"})
      {:is_password_valid, false} -> json(conn, %{message: "Password must be greater than or equal to 8 characters"})
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
