defmodule TasksApiWeb.Router do
  use TasksApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug TasksApi.GuardianPipeline
    plug TasksApiWeb.Auth.SetUser
  end

  scope "/api", TasksApiWeb do
    pipe_through :api

    post "/accounts/register", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", TasksApiWeb do
    pipe_through [:api, :auth]

    get "/task_list", TaskController, :index
    get "/task_list/by_user_id/:id", TaskController, :index_by_user_id
    get "/task_list/by_status/:status", TaskController, :index_by_status
    post "/user/take_task", TaskController, :take_task
  end
end
