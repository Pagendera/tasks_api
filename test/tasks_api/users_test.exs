defmodule TasksApi.UsersTest do
  use TasksApi.DataCase, async: true

  alias TasksApi.Users
  alias TasksApi.Users.User
  alias TasksApi.Accounts.Account

  describe "get_user!/1" do
    test "returns the user with the given id" do
      account = insert_account()
      user = insert_user(%{account_id: account.id})

      assert user == Users.get_user!(user.id)
    end

    test "raises `Ecto.NoResultsError` for an invalid id" do
      assert_raise Ecto.NoResultsError, fn ->
        Users.get_user!(123)
      end
    end
  end

  describe "get_user_by_account_id/1" do
    test "returns the user with the given account_id" do
      account = insert_account()
      user = insert_user(%{account_id: account.id})

      assert user == Users.get_user_by_account_id(account.id)
    end

    test "returns nil for a non-existent account_id" do
      assert nil == Users.get_user_by_account_id(999)
    end
  end

  describe "create_user/2" do
    test "creates a user associated with an account" do
      account = insert_account()

      assert {:ok, %User{} = user} = Users.create_user(account, %{})
      assert user.account_id == account.id
    end

    test "returns error changeset for invalid data" do
      account = insert_account()
      invalid_attrs = %{account_id: nil}

      assert {:error, changeset} = Users.create_user(account, invalid_attrs)

      refute changeset.valid?
      assert %{account_id: ["can't be blank"]} = errors_on(changeset)
    end
  end

  defp insert_user(attrs) do
    %User{}
    |> Ecto.Changeset.cast(attrs, [:account_id])
    |> Ecto.Changeset.validate_required([:account_id])
    |> Ecto.Changeset.foreign_key_constraint(:account_id)
    |> TasksApi.Repo.insert!()
  end

  defp insert_account() do
    default_attrs = %{email: "Test Account", hash_password: "password"}

    %Account{}
    |> Ecto.Changeset.cast(default_attrs, [:email, :hash_password])
    |> Ecto.Changeset.validate_required([:email, :hash_password])
    |> TasksApi.Repo.insert!()
  end
end
