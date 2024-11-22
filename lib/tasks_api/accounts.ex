defmodule TasksApi.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias TasksApi.Repo

  alias TasksApi.Accounts.Account

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Gets a single account.any()

  Returns 'nil' if the Account does not exist.

  ## Examples

    iex> get_account_by_email(test@email.com)
    %Account{}

    iex> get_account_by_email(no_account@email.com)
    nil
  """
  def get_account_by_email(email) do
    Account
    |> where(email: ^email)
    |> Repo.one()
  end

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end
end
