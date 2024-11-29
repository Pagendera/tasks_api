defmodule TasksApiWeb.Auth.GuardianPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :tasks_api,
     module: TasksApiWeb.Auth.Guardian,
    error_handler: TasksApiWeb.Plugs.GuardianErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
