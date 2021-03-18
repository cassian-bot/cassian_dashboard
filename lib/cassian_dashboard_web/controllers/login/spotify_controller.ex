defmodule CassianDashboardWeb.Login.SpotifyController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.Connections

  plug Ueberauth
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    IO.inspect(auth, label: "Spotify auth info")

    Guardian.Plug.current_resource(conn)
    |> Connections.create_or_update(auth)
    |> IO.inspect(label: "Spotify connection")

    conn
    |> redirect(to: "/")
  end
end
