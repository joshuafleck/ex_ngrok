defmodule ExNgrokTest do
  use ExUnit.Case
  @moduletag :capture_log

  setup context do
    Application.stop(:ex_ngrok)
    Application.put_env(:ex_ngrok, :api_url, context[:api_url])
  end

  @tag api_url: "http://localhost:4040/api/tunnels"
  test "it stores the settings" do
    :ok = Application.start(:ex_ngrok)

    assert ExNgrok.public_url =~ ~r/http(s)?:\/\/(.*)\.ngrok\.io/
  end

  @tag api_url: "http://localhost:0"
  test "it raises when it cannot connect to the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not connect to Ngrok API on http://localhost:0, reason: eaddrnotavail")
  end

  @tag api_url: "http://localhost:4040/not_found"
  test "it raises when it cannot find the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not find Ngrok API on http://localhost:4040/not_found, data: {\"status_code\":404,\"msg\":\"Not Found\",\"details\":{\"path\":\"/not_found\"}}\n")
  end

  @tag api_url: "https://api.pipedream.com/v1/sources"
  test "it raises when it cannot parse the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not find Ngrok API on https://api.pipedream.com/v1/sources, data:")
  end

  defp assert_application_start_error(expected_message) do
    {:error, {{:shutdown, {:failed_to_start_child, ExNgrok.Settings, {%RuntimeError{message: actual_message}, _stack_trace}}}, _info}} = Application.start(:ex_ngrok)
    assert actual_message =~ expected_message
  end
end
