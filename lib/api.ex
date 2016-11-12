defmodule Ngrok.Api do
  @moduledoc """
  Provides the ability to fetch the Ngrok settings from the Ngrok API
  - See: https://ngrok.com/docs#client-api-base
  """
  @type error :: {:error, String.t}
  @type successful_parse :: {:ok, map}
  @type successful_get :: {:ok, String.t}

  @spec first_tunnel_settings() :: error | successful_parse
  def first_tunnel_settings do
    api_url = Application.get_env(:ex_ngrok, :api_url)
    api_url
    |> get
    |> parse
    |> first_tunnel
  end

  @spec get(String.t) :: error | successful_get
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

  @spec parse(successful_get) :: error | successful_parse
  defp parse({:ok, body}) do
    case Poison.Parser.parse(body) do
      {:ok, parsed} ->
        {:ok, parsed}
      _ ->
        {:error, "Could not parse data from Ngrok API, data: #{body}"}
    end
  end
  defp parse(error), do: error

  @spec first_tunnel(successful_parse) :: error | successful_parse
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
