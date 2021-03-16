defmodule CassianDashboard.Accounts.ErrorHandler do
  import Plug.Conn
  alias Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    IO.inspect(type, label: "Type")

    conn
    |> put_status(401)
    |> Controller.put_view(CassianDashboardWeb.ErrorView)
    |> Controller.render(:"401")
  end
end
