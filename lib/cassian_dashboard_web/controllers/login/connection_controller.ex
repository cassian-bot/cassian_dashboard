defmodule CassianDashboardWeb.Login.ConnectionController do
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

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    params |> IO.inspect(label: "params")

    Guardian.Plug.current_resource(conn)
    |> Connections.create_or_update(translate_auth(auth))

    conn
    |> redirect(to: "/")
  end

  defp translate_auth(%{provider: :google} = auth),
    do: Map.put(auth, :provider, :youtube)

  defp translate_auth(auth), do: auth
end
