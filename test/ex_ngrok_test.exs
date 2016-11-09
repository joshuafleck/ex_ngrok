defmodule NgrokTest do
  use ExUnit.Case
  doctest Ngrok

  setup do
    Application.stop(:ex_ngrok)
    :ok = Application.start(:ex_ngrok)
  end

  test "it stores the settings" do
    assert Ngrok.Settings.get("public_url") =~ ~r/http:\/\/(.*)\.ngrok\.io/
  end
end
