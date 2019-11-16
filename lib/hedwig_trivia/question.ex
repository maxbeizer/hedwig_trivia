defmodule HedwigTrivia.Question do
  @moduledoc """
  Logic surrounding fetching and evaluating questions from the API
  """

  alias HedwigTrivia.Fetchers.API
  alias HedwigTrivia.GameState

  @doc """
  Call the API to fetch a new question, verify it's playable, and add the
  data to the game state.
  """
  @spec fetch(GameState.t()) :: {:ok | :error, GameState.t()}
  def fetch(state, api \\ API) do
    with {:ok, res} <- api.fetch_random(),
         :ok <- check_worthiness(res) do
      state = %{
        state
        | question: res["question"],
          answer: strip_html(res["answer"]),
          category_name: res["category"]["title"],
          value: res["value"],
          answered: false
      }

      {:ok, state}
    else
      :bad ->
        fetch(state, api)

      {:error, _} ->
        # update state for error
        {:error, state}
    end
  end

  @doc """
  Strip HTML tags from answers. There are definitely better ways to do this,
  but I'm being very lazy.
  """
  @spec strip_html(String.t()) :: String.t()
  def strip_html(raw_answer) do
    raw_answer
    |> String.replace(~r/<i>/, "", global: true)
    |> String.replace(~r/<\/i>/, "", global: true)
    |> String.replace(~r/<u>/, "", global: true)
    |> String.replace(~r/<\/u>/, "", global: true)
  end

  @doc ~S"""
  Returns :ok if the the question is not obviously unanswerable, since the
  API sometimes returns that.

  ## Examples

  iex> Question.check_worthiness(%{"question" => "asdf", "answer" => "asdf"})
  :ok

  iex> Question.check_worthiness(%{"question" => "=", "answer" => "asdf"})
  :bad

  iex> Question.check_worthiness(%{"question" => "=", "answer" => "asdf"})
  :bad
  """
  @spec check_worthiness(map()) :: :ok | :error
  def check_worthiness(res) do
    if res["question"] == "=" or res["answer"] == "=",
      do: :bad,
      else: :ok
  end
end
