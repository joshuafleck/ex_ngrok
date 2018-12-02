defmodule Ngrok.Executable do
  @moduledoc """
  Spawns a foreign process that will be terminated when the application stops
  - See: https://shift.infinite.red/foreign-processes-and-phoenix-555179c24151#.at6f31kd4
  """
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    port = Port.open(
      {:spawn, "#{Path.dirname(__ENV__.file)}/../bin/wrap #{ngrok()}"},
      [])
    {:ok, port}
  end

  @spec ngrok :: String.t
  defp ngrok do
    arguments = [
      Application.get_env(:ex_ngrok, :executable),
      protocol(),
      Application.get_env(:ex_ngrok, :port),
      Application.get_env(:ex_ngrok, :options),
    ]
    Enum.join(arguments, " ")
  end

  @spec protocol :: String.t
  defp protocol do
    case Application.get_env(:ex_ngrok, :protocol) do
      "https" ->
        "http"
      protocol ->
        protocol
    end
  end
end
