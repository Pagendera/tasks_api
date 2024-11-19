defmodule TasksApi.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :tasks_api,
     module: TasksApiWeb.Auth.Guardian,
    error_handler: TasksApi.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
