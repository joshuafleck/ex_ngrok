# ex_ngrok

A wrapper around [Ngrok](https://ngrok.com/) providing a secure tunnel to localhost for demoing your Elixir/Phoenix web application or testing webhook integrations.

Once installed, ex_ngrok will manage starting and stopping Ngrok with your application and expose Ngrok's settings to your application.

## Dependencies

- **[Ngrok](https://ngrok.com/) 2.x** Install it on OSX with:

        $ brew cask install ngrok

## Installation

Add ex_ngrok to your `mix.exs` dependencies...

from Hex:

```elixir
def deps do
  [{:ex_ngrok, "~> 0.3.0", only: [:dev]}]
end
```

or, from Github:

```elixir
def deps do
  [{:ex_ngrok, github: "joshuafleck/ex_ngrok", only: [:dev]}]
end
```

Include :ex_ngrok as an application dependency:

```elixir
# We really only want to run Ngrok in development, so
# we only start :ex_ngrok when the env is dev.
# Otherwise, it can be started manually with: Application.start(:ex_ngrok)
def application do
  [ applications: env_specific_applications(Mix.env) ]
end

def env_specific_applications(:dev) do
  [:ex_ngrok]
end

def env_specific_applications(_) do
  []
end
```

## Configuration

The default configurations may be overridden by setting any
of the following in your `config/config.exs` file:

```elixir
config :ex_ngrok,
  # The name of the Ngrok executable
  executable: "ngrok",
  # The type of tunnel (http, https, tcp, or tls)
  protocol: "http",
  # The port to which Ngrok will forward requests
  port: "4000",
  # The URL of Ngrok's API (used to retrieve its settings)
  api_url: "http://localhost:4040/api/tunnels",
  # The amount of sleep (in ms) to put between attempts to connect to Ngrok
  sleep_between_attempts: 200,
  # Any other tunneling options that will be passed directly to Ngrok
  options: ""
```

## Usage

### Retrieving your public URL

Ngrok will create a public URL that tunnels to your development machine.
The URL will change every time Ngrok starts, but you can retrieve the URL
by running the following:

```elixir
Ngrok.public_url # => http://(.*).ngrok.io/
```
