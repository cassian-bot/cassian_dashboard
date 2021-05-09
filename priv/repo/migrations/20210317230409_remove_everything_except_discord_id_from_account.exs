defmodule CassianDashboard.Repo.Migrations.RemoveEverythingExceptDiscordIdFromAccount do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      remove :avatar
      remove :token
      remove :username
    end
  end
end
