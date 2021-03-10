defmodule ExNgrok.Api do
  @moduledoc """
  Provides the ability to fetch the Ngrok settings from the Ngrok API
  - See: https://ngrok.com/docs#client-api-base
  """
  @type error :: {:error, String.t}
  @type successful_parse :: {:ok, map}
  @type successful_get :: {:ok, String.t}

  @spec tunnel_settings() :: error | successful_parse
  def tunnel_settings do
    with api_url = Application.get_env(:ex_ngrok, :api_url),
      {:ok, body} <- get(api_url),
      {:ok, parsed} <- parse(body) do
      find_tunnel(parsed)
    end
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

  @spec parse(String.t) :: error | successful_parse
  defp parse(body) do
    case Jason.decode(body) do
      {:ok, parsed} ->
        {:ok, parsed}
      {:error, _} ->
        {:error, "Could not parse data from Ngrok API, data: #{body}"}
    end
  end

  @spec find_tunnel(map) :: error | successful_parse
  defp find_tunnel(parsed) do
    tunnels = Map.fetch!(parsed, "tunnels")
    protocol = Application.get_env(:ex_ngrok, :protocol)
    case Enum.find(tunnels, &tunnel_for_protocol(&1, protocol)) do
      nil ->
        {:error, "No Ngrok tunnels found for protocol: #{protocol}"}

      tunnel ->
        {:ok, tunnel}
    end
  end

  @spec tunnel_for_protocol(map, String.t) :: boolean
  defp tunnel_for_protocol(tunnel, protocol) do
    Map.fetch!(tunnel, "proto") == protocol
  end
end
