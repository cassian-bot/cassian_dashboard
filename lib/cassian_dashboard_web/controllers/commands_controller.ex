defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.{Connections, Services.SpotifyService}

  defguardp real_provider(provider) when provider in ["spotify", "general", "youtube"]

  def index(conn, %{"provider" => provider}) when real_provider(provider) do
    IO.inspect(conn.assigns, label: "Assings")
    render(conn, "index.html",
      [
        provider: provider,
        playlists: get_playlist(conn, provider |> String.to_atom())
      ] ++ provider_key_list(conn, provider)
    )
  end

  def index(conn, _) do
    render(conn, "index.html", [provider: "general", playlists: []] ++ provider_key_list(conn, "general"))
  end

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
    |> IO.inspect(label: "Classes")
  end

  defp provider_class(provider, acc, connections, current_provider) do
    classes =
      if connections[provider] || provider == "general" do
        []
      else
        ["not-connected"]
      end ++ if current_provider == provider do
        ["selected-connection"]
      else
        []
      end
      |> Enum.join(" ")

    Keyword.put(acc, :"#{provider}_classes", classes)
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
