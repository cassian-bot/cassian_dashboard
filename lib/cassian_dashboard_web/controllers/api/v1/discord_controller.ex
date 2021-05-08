defmodule CassianDashboardWeb.Api.V1.DiscordController do
  use CassianDashboardWeb, :controller

  def show(conn, %{"id" => user_id}) do
    {status, body} = CassianDashboard.DiscordService.user_info!(user_id)

    response =
      %{
        status: to_string(status),
        body: body
      }

    render(conn, "show.json", info: response)
  end
end
