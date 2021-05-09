defmodule CassianDashboardWeb.CommandsController do
  use CassianDashboardWeb, :controller

  def index(conn, %{"provider" => provider} = params)
      when provider in ["spotify", "general", "youtube"] do
    render(conn, "index.html", provider: params["provider"], placeholder: params["placeholder"])
  end

  def index(conn, _) do
    render(conn, "index.html", provider: "general")
  end
end
