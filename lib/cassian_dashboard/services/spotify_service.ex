defmodule CassianDashboard.Services.SpotifyService do
  @moduledoc """
  Module for the Spotify service. Get account data and
  update the token.
  """

  alias CassianDashboard.{Connections, Connections.Connection}

  @token_link "https://accounts.spotify.com/api/token"
  @client_id Ueberauth.Strategy.Spotify.OAuth.client().client_id
  @client_secret Ueberauth.Strategy.Spotify.OAuth.client().client_secret
  @authorization Base.url_encode64("#{@client_id}:#{@client_secret}")

  @doc """
  Reauthorize the connection. Gives response with data.
  """
  @spec reauthorize(connection :: %Connection{}) ::
          {:ok,
           %{
             access_token: String.t(),
             expires_in: integer(),
             scope: String.t(),
             token_type: String.t()
           }}
          | {:error, integer()}
  def reauthorize(connection) do
    headers = [
      {"Authorization", "Basic #{@authorization}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    params = %{
      grant_type: "refresh_token",
      refresh_token: connection.refresh_token
    }

    case HTTPoison.post(@token_link, "", headers, params: params) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body, keys: :atoms)}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, code}
    end
  end

  @doc """
  Reuahotize the connection and save it do the database. In case of an error
  the connection is deleted.
  """
  @spec reauthorize_and_edit(connection :: %Connection{}) ::
          {:ok, %Connection{}} | {:error, %Ecto.Changeset{}}
  def reauthorize_and_edit(connection) do
    case reauthorize(connection) do
      {:ok, %{access_token: token}} ->
        Connections.update_connection(connection, %{token: token})

      {:error, _code} ->
        Connections.delete_connection(connection)
    end
  end

  defp generate_user_headers(connection) do
    [
      {"Authorization", "Bearer #{connection.token}"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end

  @playlist_link "https://api.spotify.com/v1/me/playlists"

  @doc """
  Get the playlists for a connection. Default limit is 10.
  """
  @spec get_playlists(connection :: %Connection{}, limit :: integer()) ::
          {:ok, [%{}]} | {:error, :noop}
  def get_playlists(connection, limit \\ 10) do
    headers = generate_user_headers(connection)

    case HTTPoison.get(@playlist_link, headers, params: [limit: limit]) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body, keys: :atoms).items}

      _ ->
        {:error, :noop}
    end
  end

  @search_link "https://api.spotify.com/v1/search"

  @doc """
  Search through the user playlists. Finds one which is the most similar in name.
  """
  @spec search_playlist(connection :: %Connection{}, query :: String.t()) ::
          {:ok, %{}} | {:error, :noop}
  def search_playlist(connection, query) do
    headers = generate_user_headers(connection)

    case HTTPoison.get(@search_link, headers, params: [type: "playlist", q: query, limit: 1]) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body, keys: :atoms).playlists.items |> List.first()}

      _ ->
        {:error, :noop}
    end
  end

  @doc """
  Get the tracks in a playlist.
  """
  @spec playlist_tracks(
          connection :: %Connection{:token => String.t()},
          playlist :: %{:id => String.t() | integer()}
        ) :: {:error, :noop} | {:ok, any}
  def playlist_tracks(connection, playlist) do
    id = playlist.id

    headers = generate_user_headers(connection)

    link = "https://api.spotify.com/v1/playlists/#{id}/tracks"

    case HTTPoison.get(link, headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, Jason.decode!(body, keys: :atoms).items}

      _ ->
        {:error, :noop}
    end
  end
end
