defmodule CassianDashboard.Repo.Migrations.AddJidToConnections do
  use Ecto.Migration

  def change do
    alter table(:connections) do
      add :jid, :string
    end
  end
end
