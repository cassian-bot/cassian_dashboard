defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
