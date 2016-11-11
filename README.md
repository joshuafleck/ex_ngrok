# ex_ngrok
To simplify development of Elixir applications that expect callbacks from external services, this application wraps [Ngrok](https://ngrok.com/) and will start/stop [Ngrok](https://ngrok.com/) on the command line when you start/stop your Elixir application.

## Dependencies

- **[Ngrok](https://ngrok.com/) 2.x** Install it on OSX with:

        $ brew cask install ngrok

## Installation

Add ex_ngrok to your `mix.exs` dependencies:

```elixir
def deps do
  [{:ex_ngrok, github: "joshuafleck/ex_ngrok", only: [:dev]}}]
end

def application do
  [ applications: [:ex_ngrok] ]
  # Application dependency auto-starts it, otherwise: Ngrok.start
end
```

## Configuration

The following configurations can be set (defaults shown):

```elixir
# The name of the Ngrok executable
config :ex_ngrok, executable: "ngrok"
# The type of tunnel
config :ex_ngrok, protocol: "http"
# The port to which Ngrok will forward requests
config :ex_ngrok, port: "4000"
# The URL of Ngrok's API (used to retrieve its settings)
config :ex_ngrok, api_url: "http://localhost:4040/api/tunnels"
```

## Usage

### Retrieving your public URL

Ngrok will create a public URL that tunnels to your development machine.
The URL will change every time Ngrok starts, but you can retrieve the URL
by running the following:

```elixir
Ngrok.Settings.get("public_url") # => http://(.*).ngrok.io/
```
