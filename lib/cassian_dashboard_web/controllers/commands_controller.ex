defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.Connections

  def index(conn, _params) do
    commands = [
      {"ping", nil},
      {"backward", nil},
      {"forward", nil},
      {"next", nil},
      {"play", "song url"},
      {"playlist", nil},
      {"previous", nil},
      {"repeat", "one, none, all"},
      {"shuffle", nil},
      {"unshuffle", nil}
    ]

    connections =
      Connections.connections_for_account(current_user(conn))
      |> Connections.key_map!()
      |> IO.inspect(label: "Connections")

    render(conn, "index.html", commands: commands, connections: connections)
  end
end
