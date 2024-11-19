defmodule TasksApiWeb.Router do
  use TasksApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TasksApiWeb do
    pipe_through :api
  end
end
