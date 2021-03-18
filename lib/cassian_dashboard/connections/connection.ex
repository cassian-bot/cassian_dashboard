defmodule CassianDashboard.Connections.Connection do
  use Ecto.Schema
  import Ecto.Changeset

  schema "connections" do
    field :refresh_token, :string
    field :token, :string
    field :type, :string
    field :account_id, :integer

    timestamps()
  end

  @doc false
  def changeset(connection, attrs) do
    connection
    |> cast(attrs, [:type, :token, :refresh_token])
    |> validate_required([:type, :token, :refresh_token])
    |> unique_constraint(:unique_user_connection, name: :unique_connection)
  end

  @spec params_from_oauth(auth :: %Ueberauth.Auth{}) :: %{type: String.t(), token: String.t(), refresh_token: String.t()}
  def params_from_oauth(auth) do
    %{
      type: auth.provider |> to_string(),
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token
    }
  end
end
