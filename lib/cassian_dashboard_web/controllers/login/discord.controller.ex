defmodule CassianDashboardWeb.Login.DiscordController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.{Accounts, Accounts.Account, Accounts.Guardian}

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
    user =
      Account.changeset_from_oauth(auth)
      |> Accounts.create_or_update!()

    conn
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  def delete(conn, _opts) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_flash(:error, "Can't log out if you're not logged in.")
        |> redirect(to: "/")

      _user ->
        conn
        |> Guardian.Plug.sign_out()
        |> redirect(to: "/")
    end
  end
end
