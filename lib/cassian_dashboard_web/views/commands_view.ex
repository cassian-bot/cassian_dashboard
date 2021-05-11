defmodule CassianDashboardWeb.CommandsView do
  use CassianDashboardWeb, :view

  defdelegate command!(keylist), to: CassianDashboard.Structs.Command
end
