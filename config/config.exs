# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tasks_api,
  ecto_repos: [TasksApi.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :tasks_api, TasksApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: TasksApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TasksApi.PubSub,
  live_view: [signing_salt: "0weQD2ps"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :tasks_api, TasksApiWeb.Auth.Guardian,
  issuer: "tasks_api",
  secret_key: "tCWGbBz0mK88sPJxomk4zkkFgm3AtcXjPRblVI1FxV/3khYwfnbrQ7p9/ky/E5mO"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
