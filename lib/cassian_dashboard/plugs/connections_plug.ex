defmodule CassianDashboard.Plugs.Connections do
  import Plug.Conn

  @moduledoc """
  Plug which assings connections, mostly used under `/commands`.
  """

  alias CassianDashboard.Connections

  def init(options), do: options

  def call(conn, _opts) do
    conn
    |> assign(:connections, connections(conn))
  end

  defp connections(conn) do
    conn
    |> Guardian.Plug.current_resource()
    |> Connections.connections_for_account()
    |> Connections.key_map!()
  end
end
