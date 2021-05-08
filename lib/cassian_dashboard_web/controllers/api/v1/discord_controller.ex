defmodule CassianDashboardWeb.Api.V1.DiscordController do
  use CassianDashboardWeb, :controller

  def show(conn, %{"id" => user_id}) do
    response = %{status: "ok"}
    render(conn, "show.json", info: response)
  end
end
