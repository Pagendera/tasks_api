defmodule TasksApi.Repo do
  use Ecto.Repo,
    otp_app: :tasks_api,
    adapter: Ecto.Adapters.Postgres
end
