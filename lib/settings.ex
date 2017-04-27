defmodule Ngrok.Settings do
  @moduledoc """
  Exposes Ngrok's tunnel settings
  - See: https://ngrok.com/docs#list-tunnels
  """
  require Logger

  def start_link do
    Agent.start_link(fn -> fetch_and_announce_settings() end, name: __MODULE__)
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

  @spec fetch_and_announce_settings :: map
  defp fetch_and_announce_settings do
    tunnel_settings()
    |> announce
  end

  @spec tunnel_settings :: map
  defp tunnel_settings, do: tunnel_settings(0, "")
  defp tunnel_settings(6, error_message), do: raise "Unable to retrieve setting from Ngrok: #{error_message}"
  defp tunnel_settings(total_attempts, _) do
    :timer.sleep(total_attempts * Application.get_env(:ex_ngrok, :sleep_between_attempts))
    case Ngrok.Api.tunnel_settings do
      {:ok, settings} ->
        settings
      {:error, message} ->
        tunnel_settings(total_attempts + 1, message)
    end
  end

  @spec announce(map) :: map
  defp announce(settings) do
    Logger.info "ex_ngrok: Ngrok tunnel available at #{settings["public_url"]}"
    settings
  end
end
