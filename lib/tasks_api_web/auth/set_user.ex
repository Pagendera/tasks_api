defmodule TasksApiWeb.Auth.SetUser do
  import Plug.Conn
  alias TasksApi.Users

  def init(_options) do

  end

  def call(conn, _options) do
    if conn.assigns[:user] do
      conn
    else
      account_id = get_session(conn, :account_id)

      user = Users.get_user_by_account_id(account_id)

      cond do
        account_id && user -> assign(conn, :user, user)
        true -> assign(conn, :account, nil)
      end
    end
  end
end
