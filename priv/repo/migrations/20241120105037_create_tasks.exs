defmodule TasksApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :status, :string
      add :account_id, references(:accounts)

      timestamps(type: :utc_datetime)
    end

    create index("tasks", [:account_id], unique: false)
  end
end
