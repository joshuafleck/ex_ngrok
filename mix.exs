defmodule Ngrok.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_ngrok,
     version: "0.3.4",
     elixir: "~> 1.7",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()]
  end

  def application do
    [extra_applications: [:logger],
     env: [
      api_url: "http://localhost:4040/api/tunnels",
      executable: "ngrok",
      protocol: "http",
      port: "4000",
      sleep_between_attempts: 200,
      options: "",
     ],
     mod: {Ngrok, []}]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.23.0", only: :dev, runtime: false},
      {:credo, "~> 1.5.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1.0", only: [:dev], runtime: false},
      {:httpoison, "~> 1.8.0"},
      {:jason, "~> 1.2.2"}
    ]
  end

  defp description do
    """
    A wrapper around Ngrok providing a secure tunnel to
    localhost for demoing your Elixir/Phoenix web application or testing
    webhook integrations.
    """
  end

  defp package do
    [maintainers: ["Joshua Fleck"],
     files: ["bin/wrap", "lib", "mix.exs", "README.md", "LICENSE"],
     licenses: ["MIT"],
     links: %{"Github" => "https://github.com/joshuafleck/ex_ngrok"}]
  end
end
