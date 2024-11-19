defmodule TasksApi.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :email, :string
      add :hash_password, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:accounts, [:email])
  end
end
