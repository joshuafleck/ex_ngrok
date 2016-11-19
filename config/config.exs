use Mix.Config

config :ex_ngrok,
  # The name of the Ngrok executable
  executable: "ngrok",
  # The type of tunnel (http, tcp, or tls)
  protocol: "http",
  # The port to which Ngrok will forward requests
  port: "4000",
  # The URL of Ngrok's API (used to retrieve its settings)
  api_url: "http://localhost:4040/api/tunnels"
