use Mix.Config

config :ex_ngrok, executable: "ngrok"
config :ex_ngrok, protocol: "http"
config :ex_ngrok, port: "4000"
config :ex_ngrok, api_url: "http://localhost:4040/api/tunnels"
