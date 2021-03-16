defmodule CassianDashboardWeb.Router do
  use CassianDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CassianDashboardWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/commands", CassianDashboardWeb do
    pipe_through :browser

    get "/", CommandsController, :index
  end

  scope "/login", CassianDashboardWeb.Login do
    pipe_through :browser

    scope "/discord" do
      get  "/",         DiscordController, :request
      get  "/callback", DiscordController, :callback
      post "/callback", DiscordController, :callback
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", CassianDashboardWeb do
  #   pipe_through :api
  # end
end
