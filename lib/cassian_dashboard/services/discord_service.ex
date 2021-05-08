defmodule CassianDashboard.DiscordService do
  @moduledoc """
  Module for the Discord service. Get info from users, etc.
  """

  @token Application.get_env(:cassian_dashboard, :discord_bot_token)

  @doc """
  Try to get the user info connected to the discord `user_id`.
  """
  @spec user_info!(user_id :: Snowflake.t()) :: {:ok, %{}} | {:error, %{}}
  def user_info!(user_id) do
    headers = [
      {"Authorization", "Bot #{@token}"}
    ]

    link = "https://discord.com/api/v8/users/#{user_id}"

    case HTTPoison.get(link, headers) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, body |> Jason.decode!()}
      _ ->
        {:error, %{}}
    end
  end
end
