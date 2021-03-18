defmodule CassianDashboard.Repo.Migrations.AddUserToConnection do
  use Ecto.Migration

  def change do
   alter table(:connections) do
    add :account_id, references(:accounts)
   end

   create unique_index(:connections, [:type, :account_id], name: :unique_connection)
  end
end
