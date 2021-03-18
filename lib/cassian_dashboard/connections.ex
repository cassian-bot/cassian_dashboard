defmodule CassianDashboard.Connections do
  @moduledoc """
  The Connections context.
  """

  import Ecto.Query, warn: false
  alias CassianDashboard.Repo

  alias CassianDashboard.Connections.Connection

  @doc """
  Gets a connection for an account. You can specify the provider,
  if the provider field is left nil it will list all existing connections.

  ## Examples

      iex> connections_for_account(%Account{id: 1})
      [%Connection{}]

      iex> connections_for_account(1)
      [%Connection{}]

      iex> connections_for_account(1, "spotify")
      [%Connection{type: "spotify"}]

      iex> connections_for_account(1, "asdf")
      []
  """
  @spec connections_for_account(
    account :: %CassianDashboard.Accounts.Account{} | integer(),
    provider :: String.t() | nil) :: list(%Connection{})
  def connections_for_account(account, provider \\ nil)

  def connections_for_account(account, provider) when is_integer(account) do
    query =
      from connection in Connection,
        where: connection.account_id == ^account,
        select: connection

    query =
      if provider do
        from connection in query,
          where: connection.type == ^provider
      else
        query
      end

    Repo.all(
      query
    )
  end

  def connections_for_account(account, provider) do
    connections_for_account(account.id, provider)
  end

  @doc """
  Gets a single connection.

  Raises `Ecto.NoResultsError` if the Connection does not exist.

  ## Examples

      iex> get_connection!(123)
      %Connection{}

      iex> get_connection!(456)
      ** (Ecto.NoResultsError)

  """
  def get_connection!(id), do: Repo.get!(Connection, id)

  @doc """
  Creates a connection.

  ## Examples

      iex> create_connection(%{field: value})
      {:ok, %Connection{}}

      iex> create_connection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_connection(account, auth) do
    auth =
      auth
      |> Connection.params_from_oauth()

    %Connection{account_id: account.id}
    |> Connection.changeset(auth)
    |> Repo.insert()
  end

  @doc """
  Updates a connection.

  ## Examples

      iex> update_connection(connection, %{field: new_value})
      {:ok, %Connection{}}

      iex> update_connection(connection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_connection(%Connection{} = connection, attrs) do
    connection
    |> Connection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a connection.

  ## Examples

      iex> delete_connection(connection)
      {:ok, %Connection{}}

      iex> delete_connection(connection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connection(%Connection{} = connection) do
    Repo.delete(connection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking connection changes.

  ## Examples

      iex> change_connection(connection)
      %Ecto.Changeset{data: %Connection{}}

  """
  def change_connection(%Connection{} = connection, attrs \\ %{}) do
    Connection.changeset(connection, attrs)
  end
end
