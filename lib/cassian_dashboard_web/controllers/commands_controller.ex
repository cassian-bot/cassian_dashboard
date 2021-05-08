defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  def index(conn, %{"provider" => "spotify"}) do
    render(conn, "index.html", provider: "spotify")
  end

  def index(conn, _params) do
    render(conn, "index.html", provider: "general")
  end
end
