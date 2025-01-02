Mix.install([
  {:httpoison, "~> 2.0"},
  {:jason, "~> 1.4"}
])

defmodule SlackBot do
  @slack_webhook_url "https://slack.com/api/chat.postMessage"
  @slack_token "xoxb-your-slack-token-here"

  def send_message(channel, text) do
    headers = [
      {"Authorization", "Bearer #{@slack_token}"},
      {"Content-Type", "application/json"}
    ]

    payload = %{
      "channel" => channel,
      "text" => text
    }

    case HTTPoison.post(@slack_webhook_url, Jason.encode!(payload), headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Slack request submitted")
        IO.inspect(Jason.decode!(body))

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        IO.puts("Error submitting Slack request. Status: #{status_code}")
        IO.inspect(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("Failed to send message. Reason: #{inspect(reason)}")
    end
  end
end

# Usage: Run this script with `elixir slack_bot.exs`
# Example usage:
SlackBot.send_message("your-channel-id", "Hello, Slack!")
