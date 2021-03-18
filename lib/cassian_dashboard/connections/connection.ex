defmodule CassianDashboard.Connections.Connection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "connections" do
    field :refresh_token, :string
    field :token, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:type, :token, :refresh_token])
    |> validate_required([:type, :token, :refresh_token])
  end
end
