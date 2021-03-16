defmodule CassianDashboardWeb.Login.DiscordController do
  use CassianDashboardWeb, :controller

  alias CassianDashboard.Accounts
  alias Accounts.Account

  plug Ueberauth
  alias Ueberauth.Strategy.Helpers

  def request(conn, _params) do
    render(conn, "request.html", callback_url: Helpers.callback_url(conn))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    IO.inspect("Kek")
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user =
      Account.changeset_from_oauth(auth)
      |> Accounts.create_or_update!()

    IO.inspect(user)

    conn
    |> redirect(to: "/")
  end
end
