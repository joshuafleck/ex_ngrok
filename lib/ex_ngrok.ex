defmodule Ngrok do
  @moduledoc """
  By including this application, an Ngrok
  process will be started when your application starts
  and stopped when your application stops
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Ngrok.Executable, [executable_with_arguments]),
      worker(Ngrok.Settings, []),
    ]

    opts = [strategy: :rest_for_one, name: Ngrok.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp executable_with_arguments do
    [
      Application.get_env(:ex_ngrok, :executable),
      Application.get_env(:ex_ngrok, :protocol),
      Application.get_env(:ex_ngrok, :port),
    ]
  end
end
