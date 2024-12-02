defmodule TasksApi.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :email, :string
    field :hash_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :tasks, TasksApi.Tasks.Task

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i, message: "Must have the @ sign and no spaces")
    |> unique_constraint(:email)
    |> validate_length(:password, min: 8, message: "Must be at least 8 characters")
    |> validate_confirmation(:password, message: "Passwords don't match")
    |> hash_password()
  end

  defp hash_password(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :hash_password, Bcrypt.hash_pwd_salt(password))
    end
  end
end
