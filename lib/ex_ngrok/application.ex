defmodule Ngrok.Application do
  @moduledoc false
  use Application

  def start(_type, _args) do
    children = [
      worker(ExNgrok.Executable, []),
      worker(ExNgrok.Settings, []),
    ]

    opts = [strategy: :rest_for_one, name: ExNgrok.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
