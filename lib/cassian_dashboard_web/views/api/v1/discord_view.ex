defmodule CassianDashboardWeb.Api.V1.DiscordView do
  use CassianDashboardWeb, :view

  def render("show.json", %{info: info}) do
    info
  end
end
