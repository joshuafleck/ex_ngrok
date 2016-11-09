defmodule Ngrok.Executable do
  @moduledoc """
  Spawns a foreign process that will be terminated when the application stops
  See: https://shift.infinite.red/foreign-processes-and-phoenix-555179c24151#.at6f31kd4
  """
  use GenServer

  def start_link(executable_with_arguments) do
    GenServer.start_link(__MODULE__, executable_with_arguments)
  end

  def init(executable_with_arguments) do
    port = Port.open(
      {:spawn_executable, "#{Path.dirname(__ENV__.file)}/../bin/wrap"},
      [{:args, executable_with_arguments}])
    {:ok, port}
  end
end
