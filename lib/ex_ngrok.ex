defmodule ExNgrok do
  @moduledoc """
  A convenience wrapper for running an ngrok instance within Elixir.
  """

  @doc """
  Retrieves the public URL of the Ngrok tunnel

  ## Example

      ExNgrok.public_url # => http://(.*).ngrok.io/
  """
  @spec public_url :: String.t
  def public_url do
    ExNgrok.Settings.get("public_url")
  end
end
