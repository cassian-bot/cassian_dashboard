defmodule CassianDashboard.Accounts.Guardian do
  @moduledoc """
  Module associated with Guardian auth.
  """

  use Guardian, otp_app: :cassian_dashboard

  alias CassianDashboard.Accounts

  def subject_for_token(account, _claims) do
    {:ok, "DiscordUserAccount:#{account.id}"}
  end

  def resource_from_claims(%{"sub" => "DiscordUserAccount:" <> string_id}) do
    case Integer.parse(string_id) do
      {id, ""} ->
        user = Accounts.get_account!(id)
        {:ok, user}

      _ ->
        {:error, :invalid_call}
    end
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

  def resource_from_claims(_) do
    {:error, :invalid_call}
  end
end
