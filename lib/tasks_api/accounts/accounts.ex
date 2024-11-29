defmodule TasksApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TasksApi.Repo

  alias TasksApi.Accounts.Account

  def get_account(id), do: Repo.get(Account, id)

  def get_account_by_email(email) do
    Account
    |> where(email: ^email)
    |> Repo.one()
  end

  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
