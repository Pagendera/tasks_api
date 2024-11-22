defmodule TasksApi.AccountsTest do
  use TasksApi.DataCase, async: true

  alias TasksApi.Accounts
  alias TasksApi.Accounts.Account

  describe "get_account!/1" do
    test "returns the account with the given id" do
      account = insert_account()
      fetched_account = Accounts.get_account!(account.id)

      assert fetched_account.id == account.id
      assert fetched_account.email == account.email
    end

    test "raises Ecto.NoResultsError if the account does not exist" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_account!(123456)
      end
    end
  end

  describe "get_account_by_email/1" do
    test "returns the account with the given email" do
      account = insert_account()
      fetched_account = Accounts.get_account_by_email(account.email)

      assert fetched_account.id == account.id
    end

    test "returns nil if the account does not exist" do
      assert Accounts.get_account_by_email("nonexistent@example.com") == nil
    end
  end

  describe "create_account/1" do
    test "creates an account with valid data" do
      valid_attrs = %{email: "test@example.com", hash_password: "password123"}
      assert {:ok, %Account{} = account} = Accounts.create_account(valid_attrs)

      assert account.email == "test@example.com"
      assert account.hash_password != "password123"
    end

    test "returns error changeset with invalid data" do
      invalid_attrs = %{email: nil, hash_password: nil}
      assert {:error, changeset} = Accounts.create_account(invalid_attrs)

      refute changeset.valid?
      assert %{email: ["can't be blank"], hash_password: ["can't be blank"]} = errors_on(changeset)
    end

    test "returns error if email is not unique" do
      existing_account = insert_account()
      duplicate_attrs = %{email: existing_account.email, hash_password: "password123"}

      assert {:error, changeset} = Accounts.create_account(duplicate_attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end
  end

  defp insert_account(attrs \\ %{}) do
    default_attrs = %{email: "user@example.com", hash_password: "password123"}
    {:ok, account} = Accounts.create_account(Map.merge(default_attrs, attrs))
    account
  end
end
