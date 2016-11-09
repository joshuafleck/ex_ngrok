defmodule Ngrok.Api do
  @moduledoc """
  Provides the ability to fetch the Ngrok settings from the Ngrok API
  See: https://ngrok.com/docs#client-api-base
  """

  def first_tunnel_settings do
    api_url = Application.get_env(:ex_ngrok, :api_url)
    api_url
    |> get
    |> parse
    |> first_tunnel
  end

  defp get(api_url) do
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: _, body: body}} ->
        {:error, "Could not find Ngrok API on #{api_url}, data: #{body}"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Could not connect to Ngrok API on #{api_url}, reason: #{reason}"}
    end
  end

  defp parse({:ok, body}) do
    case Poison.Parser.parse(body) do
      {:ok, json} ->
        {:ok, json}
      _ ->
        {:error, "Could not parse data from Ngrok API, data: #{body}"}
    end
  end
  defp parse(error), do: error

  defp first_tunnel({:ok, parsed}) do
    case List.first(Map.fetch!(parsed, "tunnels")) do
      nil ->
        {:error, "No Ngrok tunnels found"}
      tunnel ->
        {:ok, tunnel}
    end
  end
  defp first_tunnel(error), do: error
end
