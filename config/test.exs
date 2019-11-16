use Mix.Config

config :logger, level: :error

config :hedwig_trivia,
  http: HedwigTrivia.Fetchers.HTTPMock,
  fetcher: HedwigTriviaMock
