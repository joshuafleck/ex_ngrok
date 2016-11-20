defmodule NgrokTest do
  use ExUnit.Case
  doctest Ngrok
  @moduletag :capture_log
  ExUnit.Case.register_attribute __ENV__, :custom_configuration

  setup context do
    Application.stop(:ex_ngrok)
    Application.put_env(:ex_ngrok, :api_url, context.registered.custom_configuration[:api_url])
  end

  @custom_configuration api_url: "http://localhost:4040/api/tunnels"
  test "it stores the settings" do
    :ok = Application.start(:ex_ngrok)

    assert Ngrok.public_url =~ ~r/http(s)?:\/\/(.*)\.ngrok\.io/
  end

  @custom_configuration api_url: "http://localhost:0"
  test "it raises when it cannot connect to the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not connect to Ngrok API on http://localhost:0, reason: eaddrnotavail")
  end

  @custom_configuration api_url: "http://localhost:4040/not_found"
  test "it raises when it cannot find the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not find Ngrok API on http://localhost:4040/not_found, data: {\"status_code\":404,\"msg\":\"Not Found\",\"details\":{\"path\":\"/not_found\"}}\n")
  end

  @custom_configuration api_url: "https://github.com/"
  test "it raises when it cannot parse the Ngrok API" do
    assert_application_start_error("Unable to retrieve setting from Ngrok: Could not parse data from Ngrok API, data:")
  end

  defp assert_application_start_error(expected_message) do
    {:error, {{:shutdown, {:failed_to_start_child, Ngrok.Settings, {%RuntimeError{message: actual_message}, _stack_trace}}}, _info}} = Application.start(:ex_ngrok)
    assert actual_message =~ expected_message
  end
end
