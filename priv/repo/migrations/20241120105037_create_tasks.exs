defmodule TasksApi.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :string
      add :status, :string
      add :user_id, references(:users)

      timestamps(type: :utc_datetime)
    end

    create index(:tasks, [:title, :description])
  end
end
