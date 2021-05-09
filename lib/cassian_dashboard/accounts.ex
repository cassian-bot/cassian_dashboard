defmodule CassianDashboard.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CassianDashboard.Repo

  alias CassianDashboard.Accounts.Account

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
  end

  def from_discord_id(discord_id) when is_nil(discord_id) do
    nil
  end

  def from_discord_id(discord_id) do
    Repo.one(
      from account in Account,
        where: account.discord_id == ^discord_id,
        select: account
    )
  end

  def create_or_update!(opts \\ %{}) do
    (from_discord_id(Map.get(opts, :discord_id)) || %Account{})
    |> Account.changeset(opts)
    |> Repo.insert_or_update!()
  end
end
