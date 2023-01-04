defmodule ExOpentok.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_opentok,
      version: "0.1.0",
      elixir: "~> 1.2",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:joken, "~> 1.4.1"},
      {:tesla, "~> 1.4"},
      {:poison, "~> 2.0"},
      {:credo, "~> 1.6", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    A Wrapper of Open Tok (Tokbox) API for elixir.
    This OpenTok Elixir SDK lets you generate sessions and tokens for OpenTok applications, and archive OpenTok sessions.
    """
  end

  defp package do
    [
      name: :ex_opentok,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Ólafur Arason"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/betterup/ex_opentok",
        "Docs" => "https://github.com/betterup/ex_opentok"
      }
    ]
  end
end
