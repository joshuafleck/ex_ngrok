defmodule Ngrok.Settings do
  @moduledoc """
  Exposes Ngrok's tunnel settings
  See: https://ngrok.com/docs#list-tunnels
  """

  def start_link do
    Agent.start_link(fn -> first_tunnel_settings end, name: __MODULE__)
  end

  @spec get(String.t) :: String.t | map | nil
  def get(field_name) do
    Agent.get(__MODULE__, &Map.get(&1, field_name))
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
end
