defmodule TasksApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TasksApiWeb.Telemetry,
      TasksApi.Repo,
      {DNSCluster, query: Application.get_env(:tasks_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TasksApi.PubSub},
      # Start a worker by calling: TasksApi.Worker.start_link(arg)
      # {TasksApi.Worker, arg},
      # Start to serve requests, typically the last entry
      TasksApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TasksApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TasksApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
