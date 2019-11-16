defmodule HedwigTrivia.Logic do
  @moduledoc """
  A home for the business logic of fetching/answering questions.
  """

  alias HedwigTrivia.{
    Answer,
    GameState,
    Question
  }

  @type force_new :: boolean()

  @incorrect_prefixes [
    "No. Sorry ",
    "I'm afraid "
  ]
  @correct_prefixes [
    "Yes! ",
    "Bingo! ",
    "You got it! "
  ]

  @doc """
  Fetch a new question if need be, but return a state with the correct game
  information.
  """
  @spec question(GameState.t(), force_new()) ::
          {:ok | :error | :not_answered, GameState.t()}
  def question(%{answered: answered} = state, false) do
    if answered do
      Question.fetch(state)
    else
      {:not_answered, state}
    end
  end

  # force a new question fetch
  def question(state, true), do: Question.fetch(state)

  @doc """
  Determine if the user-supplied guess matches the answer.
  """
  @spec guess(GameState.t(), String.t()) ::
          {:ok | :error | :already_answered, GameState.t()}
  def guess(%{answer: answer, answered: false} = state, guess) do
    if Answer.correct_or_close_enough?(answer, guess) do
      state = %{state | answered: true}
      {:ok, state}
    else
      # Just to be sure, let's set the answered state to false
      state = %{state | answered: false}
      {:error, state}
    end
  end

  def guess(%{answered: true} = state, _guess), do: {:already_answered, state}

  @doc """
  Mark the question as answered and return the game state so the answer can
  be revelead
  """
  @spec solution(GameState.t()) :: {:ok | :error, GameState.t()}
  def solution(%{answer: answer} = state) when is_nil(answer) or answer == "" do
    {:error, %{state | answered: true}}
  end

  def solution(state), do: {:ok, %{state | answered: true}}

  @doc """
  Build up the full response from the category, value, and question
  """
  @spec compose_full_question(GameState.t()) :: String.t()
  def compose_full_question(%{
        question: question,
        category_name: category_name,
        value: value
      }) do
    "_#{category_name}_[$#{value}] #{question}"
  end

  @doc """
  Given a guess, return a string representing a response from the bot[]
  """
  @spec incorrect(String.t()) :: String.t()
  def incorrect(guess) do
    Enum.random(@incorrect_prefixes) <> guess <> " is incorrect"
  end

  @doc """
  Given a guess, return a string representing a response from the bot[]
  """
  @spec correct(String.t()) :: String.t()
  def correct(guess) do
    Enum.random(@correct_prefixes) <> guess <> " is correct"
  end
end
