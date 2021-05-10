defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.{Connections, Services.SpotifyService}

  defguardp real_provider(provider) when provider in ["spotify", "general", "youtube", "soundcloud"]

  # Controller stuff

  def index(conn, %{"provider" => provider}) when real_provider(provider) do
    render(
      conn,
      "index.html",
      [
        provider: provider,
        playlists: get_playlist(conn, provider |> String.to_atom())
      ] ++ provider_key_list(conn, provider)
    )
  end

  def index(conn, _) do
    render(
      conn,
      "index.html",
      [provider: "general", playlists: []] ++ provider_key_list(conn, "general")
    )
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

  # Functions which generate classes for providers, really only has
  # value with css, otherwise doesn't affect any data

  defp provider_key_list(conn, provider) do
    user = current_user(conn)

    all =
      if user do
        []
      else
        "unauthenticated"
      end

    # The values are set via the `CassianDashboard.Plugs.Connections` plug!
    connections = conn.assigns.connections

    ["spotify", "soundcloud", "youtube", "general"]
    |> Enum.reduce([all: all], &provider_class(&1, &2, connections, provider))
  end

  defp provider_class(provider, acc, connections, current_provider) do
    classes =
      (connection_class(connections, provider) ++ selected_class(provider, current_provider))
      |> Enum.join(" ")

    Keyword.put(acc, :"#{provider}_classes", classes)
  end

  defp connection_class(_connections, "general"), do: []

  defp connection_class(_connections, "soundcloud"), do: []

  defp connection_class(connections, provider) do
    if connections[provider] do
      []
    else
      ["not-connected"]
    end
  end

  defp selected_class(one, two) when one == two,
    do: ["selected-connection"]

  defp selected_class(_one, _two), do: []
end
