defmodule CassianDashboard.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "accounts" do
    field :discord_id, :integer

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:discord_id])
    |> validate_required([:discord_id])
    |> unique_constraint(:discord_id)
  end

  @spec changeset_from_oauth(auth :: %Ueberauth.Auth{}) :: %{
    discord_id: integer()
  }
  def changeset_from_oauth(auth) do
    discord_id = auth.uid |> String.to_integer()

    %{
      discord_id: discord_id,
    }
  end
end
