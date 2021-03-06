defmodule CassianDashboardWeb.Router do
  use CassianDashboardWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :connections do
    plug CassianDashboard.Plugs.Connections
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
      pipe_through :connections

      get "/", CommandsController, :index
    end
  end

  scope "/api", CassianDashboardWeb.Api do
    pipe_through :api

    scope "/v1", V1 do
      scope "/discord" do
        get "/:id", DiscordController, :show
      end
    end
  end

  # Everything having to do with oauth.
  scope "/auth", CassianDashboardWeb.Login do
    pipe_through [:browser, :auth]

    scope "/discord" do
      get "/", DiscordController, :request
      get "/logout", DiscordController, :delete
      get "/callback", DiscordController, :callback
      post "/callback", DiscordController, :callback
    end

    scope "/spotify" do
      pipe_through :ensure_auth

      get "/", SpotifyController, :request
      get "/callback", SpotifyController, :callback
      post "/callback", SpotifyController, :callback
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", CassianDashboardWeb do
  #   pipe_through :api
  # end
end
