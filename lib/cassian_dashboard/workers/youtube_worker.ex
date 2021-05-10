defmodule CassianDashboard.Workers.YoutubeWorker do
  @moduledoc """
  Worker module which will reauthenticate spotify connections (or delete 'em).
  """

  alias CassianDashboard.{Connections, Connections.Connection}

  @doc false
  def perform(connection_id) do
    Connections.get_connection(connection_id)
    |> reauthorize_or_delete()
  end

  def enqueue(connection) do
    case Exq.enqueue_in(Exq, "youtube", 300, __MODULE__ |> to_string(), [connection.id]) do
      {:ok, jid} ->
        Connections.update_connection(connection, %{jid: jid})
    end
  end

  @spec reauthorize_or_delete(connection :: %Connection{} | nil) :: nil
  def reauthorize_or_delete(_), do: nil
end
