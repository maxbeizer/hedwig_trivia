defmodule HedwigTrivia.Responders do
  @moduledoc """
  Let's play trivia!

  This module holds the responders to interact with HedwigTrivia.
  """

  use Hedwig.Responder

  @fetcher Application.get_env(:hedwig_trivia, :fetcher)

  @usage """
  hedwig trivia - displays a trivia category and question
  """
  respond ~r/trivia$/iu, msg do
    response =
      case @fetcher.question do
        {:ok, question} -> question
        {:not_answered, err} -> err
        {:error, err} -> err
      end

    send(msg, response)
  end

  @usage """
  hedwig trivia! - displays a brand new trivia category and question
  """
  respond ~r/trivia!$/iu, msg do
    response =
      case @fetcher.question(true) do
        {:ok, question} -> question
        {:error, err} -> err
      end

    send(msg, response)
  end

  @usage """
  hedwig solution - returns the answer for the current trivia question
  """
  respond ~r/solution$/iu, msg do
    response =
      case @fetcher.solution() do
        {:ok, res} -> res
        {:error, err} -> err
      end

    send(msg, response)
  end

  @usage """
  hedwig guess <guess> - submits a guess for the current trivia question
  """
  respond ~r/guess\s+(?<guess>.+)$/iu, %{matches: %{"guess" => guess}} = msg do
    response =
      case @fetcher.guess(guess) do
        {:ok, res} -> res
        {:error, err} -> err
      end

    send(msg, response)
  end
end
