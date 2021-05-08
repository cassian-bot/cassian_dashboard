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

    case Guardian.Plug.current_resource(conn) do
      nil ->
        nil
      account ->
      Connections.connections_for_account(account)
      |> Connections.key_map!()
    end
  end
end
