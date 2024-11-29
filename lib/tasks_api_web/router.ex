defmodule TasksApiWeb.Router do
  use TasksApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug TasksApiWeb.Auth.GuardianPipeline
    plug TasksApiWeb.Plugs.SetAccount
  end

  scope "/api", TasksApiWeb do
    pipe_through :api

    post "/accounts/register", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", TasksApiWeb do
    pipe_through [:api, :auth]

    get "/task_list", TaskController, :index
    post "/user/take_task", TaskController, :take_task
  end
end
