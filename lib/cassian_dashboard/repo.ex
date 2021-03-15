defmodule CassianDashboard.Repo do
  use Ecto.Repo,
    otp_app: :cassian_dashboard,
    adapter: Ecto.Adapters.Postgres
end
