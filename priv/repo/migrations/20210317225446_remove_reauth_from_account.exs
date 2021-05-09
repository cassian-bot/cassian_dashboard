defmodule CassianDashboard.Repo.Migrations.RemoveReauthFromAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      remove :expires_at
      remove :refresh_token
    end
  end
end
