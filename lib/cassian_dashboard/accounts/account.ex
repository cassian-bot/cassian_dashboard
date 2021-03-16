defmodule CassianDashboard.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :avatar, :string
    field :discord_id, :string
    field :refresh_token, :string
    field :token, :string
    field :username, :string
    field :valid_until, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:discord_id, :avatar, :username, :token, :valid_until, :refresh_token])
    |> validate_required([:discord_id, :avatar, :username, :token, :valid_until, :refresh_token])
    |> unique_constraint(:discord_id)
  end
end
