defmodule CassianDashboard.Connections do
  @moduledoc """
  The Connections context.
  """

  import Ecto.Query, warn: false
  alias CassianDashboard.Repo

  alias CassianDashboard.Connections.Connection
  alias CassianDashboard.Accounts.Account

  alias Ueberauth.Auth

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
          account :: %Account{} | integer(),
          provider :: String.t() | nil
        ) :: list(%Connection{})
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

    Repo.all(query)
  end

  def connections_for_account(account, provider) do
    connections_for_account(account.id, provider)
  end

  @doc """
  Get the connection for a specific provider from the account.

  ## Examples

      iex> connection_for_account(%Account{id: 1}, "spotify")
      %Connection{type: "spotify", account_id: 1}

      iex> connection_for_account(1, "spotify")
      %Connection{type: "spotify", account_id: 1}

      iex> connection_for_account(-1, "spotify")
      nil
  """
  @spec connection_for_account(account :: %Account{} | integer(), provider :: String.t()) ::
          %Connection{} | nil
  def connection_for_account(account, provider) when is_integer(account) do
    Repo.one(
      from connection in Connection,
        where: connection.account_id == ^account and connection.type == ^provider,
        select: connection
    )
  end

  def connection_for_account(account, provider) do
    connection_for_account(account.id, provider)
  end

  @doc """
  Get a single connection without an error.

  ## Examples

      iex> get_connection(123)
      %Connection{}

      iex> get_connection(456)
      nil
  """
  @spec get_connection(id :: integer()) :: %Connection{} | nil
  def get_connection(id), do: Repo.get(Connection, id)

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
  Create or update the connection for an account.

  ## Examples

      iex> create_or_update(%Account{id: 10}, %Auth{})
      {:ok, %Connection{}}

      iex> create_or_update(%Account{id: -10}, %Auth{})
      {:error, %Ecto.Changeset{}}
  """
  @spec create_or_update(account :: %Account{}, auth :: %Auth{}) ::
          {:ok, %Connection{}} | {:error, %Ecto.Changeset{}}
  def create_or_update(account, auth) do
    params = Connection.params_from_oauth(auth)

    resp =
      (connection_for_account(account, params.type) || %Connection{account_id: account.id})
      |> Connection.changeset(params)
      |> Repo.insert_or_update()

    case resp do
      {:ok, connection} ->
        :"Elixir.CassianDashboard.Workers.#{String.capitalize(connection.type)}Worker".enqueue(
          connection
        )
    end

    resp
  end

  @doc """
  List all of the existing connections of a specific type.

  ## Examples

      iex> list_connections "spotify"
      [%Connection{type: "spotify"}]
  """
  @spec list_connections(type :: String.t()) :: list(%Connection{})
  def list_connections(type) do
    Repo.all(
      from connection in Connection,
        where: connection.type == ^type,
        select: connection
    )
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
  Deletes a connection. Also deleted the sheduled job.

  ## Examples

      iex> delete_connection(connection)
      {:ok, %Connection{}}

      iex> delete_connection(connection)
      {:error, %Ecto.Changeset{}}

  """
  def delete_connection(%Connection{} = connection) do
    data = Repo.delete(connection)
    Exq.Api.remove_scheduled(Exq.Api, connection.jid)
    data
  end

  @spec key_map!(connections :: [%Connection{}]) :: %{String.t() => %Connection{}}
  @doc """
  Reduce connections in a key-map value where the key is the connection type.
  """
  def key_map!(connections \\ []) do
    Enum.reduce(connections, %{}, fn connection, acc ->
      Map.put(acc, connection.type, connection)
    end)
  end
end
