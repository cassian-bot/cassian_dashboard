# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :cassian_dashboard,
  ecto_repos: [CassianDashboard.Repo]

# Configures the endpoint
config :cassian_dashboard, CassianDashboardWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Yd9FHHsujTbid5X3qo+usTAeIELm2eEvR8sFKmCHbLNGH60oLLyXE525Pa9h+HgQ",
  render_errors: [view: CassianDashboardWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CassianDashboard.PubSub,
  live_view: [signing_salt: "4xbtx4V5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Setup oauth2 for Discord
config :ueberauth, Ueberauth,
  base_path: "/auth",
  providers: [
    discord: {Ueberauth.Strategy.Discord, []}
  ]

# Added here as we'll need it in both dev and prod
config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
  client_id: System.get_env("DISCORD_CLIENT_ID"),
  client_secret: System.get_env("DISCORD_CLIENT_SECRET")

config :cassian_dashboard, CassianDashboard.Accounts.Guardian,
  issuer: :cassian_dashboard,
  ttl: { 7, :days }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
