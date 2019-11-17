defmodule HedwigTrivia.MixProject do
  use Mix.Project

  @vsn "0.1.0"

  def project do
    [
      app: :hedwig_trivia,
      version: @vsn,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps(),
      description: "A trivia game plugin for Hedwig.",
      package: [
        name: "hedwig_trivia",
        files: ~w(lib .formatter.exs mix.exs README* LICENSE* CHANGELOG*),
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/maxbeizer/hedwig_trivia"}
      ],
      source_url: "https://github.com/maxbeizer/hedwig_trivia",
      homepage_url: "https://github.com/maxbeizer/hedwig_trivia"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:hedwig, "~> 1.0"},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 3.1"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
