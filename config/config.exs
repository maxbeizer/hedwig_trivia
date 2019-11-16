use Mix.Config

config :hedwig_trivia,
  http: HedwigTrivia.Fetchers.HTTP,
  fetcher: HedwigTrivia

import_config "#{Mix.env()}.exs"
