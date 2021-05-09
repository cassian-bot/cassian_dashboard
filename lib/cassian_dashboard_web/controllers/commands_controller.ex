defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.{Connections, Services.SpotifyService}

  defguardp real_provider(provider) when provider in ["spotify", "general", "youtube"]

  def index(conn, %{"provider" => provider}) when real_provider(provider) do
    render(conn, "index.html",
      provider: provider,
      playlists: get_playlist(conn, provider |> String.to_atom())
    )
  end

  def index(conn, _) do
    render(conn, "index.html", provider: "general", playlists: [])
  end

  @doc """
  Get playlists for specific connections.
  """
  @spec get_playlist(conn :: %Plug.Conn{}, provider :: :spotify | any()) :: [
          %{name: String.t(), link: String.t()}
        ]
  def get_playlist(conn, :spotify) do
    user = current_user(conn)

    case Connections.connection_for_account(user, "spotify") do
      nil ->
        []

      connection ->
        case SpotifyService.get_playlists(connection) do
          {:ok, playlists} ->
            Enum.map(playlists, fn p -> %{name: p.name, link: p.external_urls.spotify} end)

          _ ->
            []
        end
    end
  end

  def get_playlist(_conn, _), do: []
end
