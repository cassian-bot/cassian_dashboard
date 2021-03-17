defmodule CassianDashboard.Accounts.ErrorHandler do
  import Plug.Conn
  alias Phoenix.Controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_unauthorized, _reason}, _opts) do
    conn
    |> put_status(401)
    |> Controller.put_view(CassianDashboardWeb.ErrorView)
    |> Controller.render(:"401")
  end

  # TODO: Add custom displays for these errors.

  # @impl Guardian.Plug.ErrorHandler
  # def auth_error(conn, {:invalid_token, _reason}, _opts) do
  #   conn
  #   |> put_status(401)
  #   |> Controller.put_view(CassianDashboardWeb.ErrorView)
  #   |> Controller.render(:"401")
  # end

  # @impl Guardian.Plug.ErrorHandler
  # def auth_error(conn, {:already_authenticated, _reason}, _opts) do
  #   conn
  #   |> put_status(403)
  #   |> Controller.put_view(CassianDashboardWeb.ErrorView)
  #   |> Controller.render(:"403")
  # end

  # @impl Guardian.Plug.ErrorHandler
  # def auth_error(conn, {:no_resource_found, _reason}, _opts) do
  #   conn
  #   |> put_status(401)
  #   |> Controller.put_view(CassianDashboardWeb.ErrorView)
  #   |> Controller.render(:"401")
  # end
end
