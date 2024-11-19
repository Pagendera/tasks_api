defmodule TasksApiWeb.Router do
  use TasksApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TasksApi.GuardianPipeline
  end

  scope "/api", TasksApiWeb do
    pipe_through :api

    post "/accounts/register", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", TasksApiWeb do
    pipe_through [:api, :auth]

    get "/accounts", AccountController, :index
  end
end
