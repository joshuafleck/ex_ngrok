use Mix.Config

config :ex_ngrok,
  api_url: "http://localhost:4040/api/tunnels",
  executable: "ngrok",
  protocol: "http",
  port: "4000",
  sleep_between_attempts: 200,
  options: ""
