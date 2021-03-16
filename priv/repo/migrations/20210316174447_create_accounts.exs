defmodule CassianDashboard.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :discord_id, :bigint
      add :avatar, :string
      add :username, :string
      add :token, :string
      add :valid_until, :utc_datetime
      add :refresh_token, :string

      timestamps()
    end

    create unique_index(:accounts, [:discord_id])
  end
end
