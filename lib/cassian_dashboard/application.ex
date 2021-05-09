defmodule CassianDashboard.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CassianDashboard.Repo,
      # Start the Telemetry supervisor
      CassianDashboardWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CassianDashboard.PubSub},
      # Start the Endpoint (http/https)
      CassianDashboardWeb.Endpoint,
      # Start a worker by calling: CassianDashboard.Worker.start_link(arg)
      # {CassianDashboard.Worker, arg}
      %{
        id: Exq,
        start: {Exq, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CassianDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CassianDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
