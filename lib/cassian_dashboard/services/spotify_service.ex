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
end
