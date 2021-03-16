defmodule CassianDashboard.Repo.Migrations.RenameValidUntilToExpiresAt do
  use Ecto.Migration

  def change do
    rename table(:accounts), :valid_until, to: :expires_at
  end
end
