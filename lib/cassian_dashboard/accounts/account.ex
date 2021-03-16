defmodule CassianDashboard.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :avatar, :string
    field :discord_id, :integer
    field :refresh_token, :string
    field :token, :string
    field :username, :string
    field :expires_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:discord_id, :avatar, :username, :token, :expires_at, :refresh_token])
    |> validate_required([:discord_id, :avatar, :username, :token, :expires_at, :refresh_token])
    |> unique_constraint(:discord_id)
  end

  @spec changeset_from_oauth(auth :: %Ueberauth.Auth{}) :: %{
    avatar: String.t(),
    discord_id: integer(),
    refresh_token: String.t(),
    token: String.t(),
    username: String.t(),
    expires_at: DateTime.t()
  }
  def changeset_from_oauth(auth) do
    expires_at = DateTime.from_unix!(auth.credentials.expires_at)
    token = auth.credentials.token
    refresh_token = auth.credentials.refresh_token
    discord_id = auth.uid |> String.to_integer()
    username = auth.info.nickname
    avatar = auth.extra.raw_info.user["avatar"]

    %{
      expires_at: expires_at,
      token: token,
      refresh_token: refresh_token,
      discord_id: discord_id,
      username: username,
      avatar: avatar
    }
  end
end
