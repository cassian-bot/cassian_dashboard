defmodule CassianDashboard.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :type, :string
      add :token, :string
      add :refresh_token, :string

      timestamps()
    end

  end
end
