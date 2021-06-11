defmodule CassianDashboard.Workers.SpotifyWorker do
  @moduledoc """
  Worker module which will reauthenticate spotify connections (or delete 'em).
  """

  alias CassianDashboard.Services.SpotifyService
  alias CassianDashboard.{Connections, Connections.Connection}

  @doc false
  def perform(connection_id) do
    Connections.get_connection(connection_id)
    |> reauthorize_or_delete()
  end

  def enqueue(connection) do
    case Exq.enqueue_in(Exq, "spotify", 300, __MODULE__ |> to_string(), [connection.id]) do
      {:ok, jid} ->
        Connections.update_connection(connection, %{jid: jid})
    end
  end

  @spec reauthorize_or_delete(connection :: %Connection{} | nil) :: nil | {:ok, pid()}
  def reauthorize_or_delete(nil), do: nil

  def reauthorize_or_delete(connection) do
    case SpotifyService.reauthorize_and_edit(connection) do
      {:ok, {:ok, _}} ->
        # Redo everything after 50 minutes.
        enqueue(connection)

      _ ->
        nil
    end
  end
end
