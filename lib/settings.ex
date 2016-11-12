defmodule Ngrok.Settings do
  @moduledoc """
  Exposes Ngrok's tunnel settings
  See: https://ngrok.com/docs#list-tunnels
  """

  def start_link do
    Agent.start_link(fn -> announce_settings end, name: __MODULE__)
  end

  @doc """
  Retrieves a setting by name from the Ngrok tunnel

  - [List of available settings](https://ngrok.com/docs#list-tunnels)

  ## Example

  Get the public URL of the Ngrok tunnel

      Ngrok.Settings.get("public_url")
  """
  @spec get(String.t) :: String.t | map | nil
  def get(field_name) do
    Agent.get(__MODULE__, &Map.get(&1, field_name))
  end

  @spec announce_settings :: map
  defp announce_settings do
    settings = first_tunnel_settings
    announce(settings)
    settings
  end

  @spec first_tunnel_settings :: map
  defp first_tunnel_settings(), do: first_tunnel_settings(0, "")
  defp first_tunnel_settings(6, error_message), do: raise "Unable to retrieve setting from Ngrok: #{error_message}"
  defp first_tunnel_settings(total_attempts, _) do
    :timer.sleep(total_attempts * 100)
    case Ngrok.Api.first_tunnel_settings do
      {:ok, settings} ->
        settings
      {:error, message} ->
        first_tunnel_settings(total_attempts + 1, message)
    end
  end

  @spec announce(map) :: :ok
  defp announce(settings) do
    IO.puts "ex_ngrok: Ngrok tunnel available at #{settings["public_url"]}"
  end
end
