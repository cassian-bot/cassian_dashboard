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

  pipeline :auth do
    plug CassianDashboard.Accounts.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", CassianDashboardWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    scope "/commands" do
      pipe_through :ensure_auth

      get "/commands", CommandsController, :index
    end

  end

  scope "/auth", CassianDashboardWeb.Login do
    pipe_through [:browser, :auth]

    scope "/discord" do
      get  "/",         DiscordController, :request
      get "/logout",       DiscordController, :delete
      get  "/callback", DiscordController, :callback
      post "/callback", DiscordController, :callback
    end

  end

  # Other scopes may use custom stacks.
  # scope "/api", CassianDashboardWeb do
  #   pipe_through :api
  # end
end
