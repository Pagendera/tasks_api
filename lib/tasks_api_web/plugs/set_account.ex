defmodule TasksApiWeb.Plugs.SetAccount do
  import Plug.Conn
  alias TasksApi.Accounts

  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:account] do
      conn
    else
      account_id = get_session(conn, :account_id)

      account = Accounts.get_account(account_id)

      cond do
        account_id && account -> assign(conn, :account, account)
        true -> assign(conn, :account, nil)
      end
    end
  end
end
