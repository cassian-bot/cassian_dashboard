defmodule CassianDashboardWeb.Api.V1.SpotifyView do
  use CassianDashboardWeb, :view

  def render("index_playlists.json", %{playlists: playlists}) do
    playlists
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end
end
