defmodule Ngrok.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_ngrok,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package(),
     description: description()]
  end

  def application do
    [applications: [:logger, :httpoison],
     mod: {Ngrok, []}]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev},
      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev]},
      {:httpoison, "~> 0.9"},
      {:poison, "~> 2.0"}
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
