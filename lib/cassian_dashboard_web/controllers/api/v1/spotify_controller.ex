defmodule CassianDashboardWeb.Api.V1.SpotifyController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.{Connections, Connections.Connection}

  def index_playlists(conn, %{"id" => id}) do
    case Connections.get_connection(id) do
      nil ->
        # Connection not found
        put_status(conn, 404)
        |> render("error.json", message: "Not found")

      connection ->
        # Connection found
        case spotify_type(connection) do
          {:ok, connection} ->
            # It's a spotify connection.
            case CassianDashboard.Services.SpotifyService.get_playlists(connection) do
              {:ok, playlists} ->
                # All is okay
                render(conn, "index_playlists.json",
                  playlists:
                    Enum.map(playlists, fn p -> %{name: p.name, link: p.external_urls.spotify} end)
                )

              _ ->
                # Spotify made an oof
                put_status(conn, 503)
                |> render("error.json", message: "Spotify issue.")
            end

          {:error, _} ->
            # Found but it's not a spotify connection...
            put_status(conn, 403)
            render(conn, "error.json", message: "Yeah, no!")
        end
    end
  end

  @doc """
  Check whether the connection is for spotify...
  """
  @spec spotify_type(connection :: %Connection{}) :: {:ok, %Connection{}} | {:error, :noop}
  def spotify_type(connection) do
    case connection.type do
      "spotify" ->
        {:ok, connection}

      _ ->
        {:error, :noop}
    end
  end
end
