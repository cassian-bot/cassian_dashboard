defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.Connections

  def index(conn, params) do
    provider = params["provider"] || "general"

    connections =
      Connections.connections_for_account(current_user(conn))
      |> Connections.key_map!()

    render(conn, "index.html", connections: connections, provider: provider)
  end
end
