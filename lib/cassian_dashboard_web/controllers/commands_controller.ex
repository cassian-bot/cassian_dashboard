defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

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

    Guardian.Plug.current_resource(conn) |> IO.inspect(label: "User")

    render(conn, "index.html", commands: commands)
  end
end
