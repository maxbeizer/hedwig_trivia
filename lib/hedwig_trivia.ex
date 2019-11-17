defmodule HedwigTrivia do
  @moduledoc """
  A GenServer to hold the state and provide a general API to the game.
  """
  use GenServer
  require Logger

  alias HedwigTrivia.{
    GameState,
    Logic
  }

  @name __MODULE__
  @error_fetching_question "There was an error fetching the question"
  @error_fetching_answer "I've lost track of the question. Please request another question"

  @doc false
  @spec start_link(map()) :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link(config \\ %{}) do
    GenServer.start_link(@name, config, name: @name)
  end

  @doc """
  Debug the current game state.
  """
  @spec state() :: GameState.t()
  def state do
    GenServer.call(@name, :state)
  end

  @doc """
  Fetch a random question.
  """
  @spec question(boolean()) :: {atom(), String.t()}
  def question(new \\ false) do
    GenServer.call(@name, {:question, new})
  end

  @doc """
  Return the actual answer to the question. For use when the user has given up.
  """
  @spec solution() :: {atom(), String.t()}
  def solution do
    GenServer.call(@name, :solution)
  end

  @doc """
  Check the user's guess against the right answer.
  """
  @spec guess(String.t()) :: {atom(), String.t()}
  def guess(guess) do
    GenServer.call(@name, {:guess, guess})
  end

  @impl true
  @spec init(map()) :: {:ok, GameState.t()}
  def init(options) do
    if options[:debug] do
      Logger.info("trivia.start " <> inspect(options))
    end

    {:ok, GameState.new(options)}
  end

  @impl true
  @spec handle_call(:state, any(), GameState.t()) ::
          {:reply, GameState.t(), GameState.t()}
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  @spec handle_call({:question, boolean()}, any(), GameState.t()) ::
          {:reply, String.t(), GameState.t()}
  def handle_call({:question, new}, _from, state) do
    maybe_debug("trivia.question new:#{new}", state)

    {atom, state, response} = fetch_question(state, new)

    {:reply, {atom, response}, state}
  end

  @impl true
  @spec handle_call(:solution, any(), GameState.t()) ::
          {:reply, String.t(), GameState.t()}
  def handle_call(:solution, _from, state) do
    maybe_debug("trivia.solution", state)

    {atom, state, response} =
      case state.answer do
        "" ->
          # The bot has lost track of or never been asked a question, go get one
          {_, state, _} = fetch_question(state, true)
          {:error, state, @error_fetching_answer}

        _ ->
          state = %{state | answered: true}
          {:ok, state, state.answer}
      end

    {:reply, {atom, response}, state}
  end

  @impl true
  @spec handle_call({:guess, String.t()}, any(), GameState.t()) ::
          {:reply, String.t(), GameState.t()}
  def handle_call({:guess, guess}, _from, state) do
    maybe_debug("trivia.guess guess: #{guess}", state)

    {atom, state, response} =
      case Logic.guess(state, guess) do
        {:error, _} ->
          {:error, state, Logic.incorrect(guess)}

        {:ok, state} ->
          {:ok, state, Logic.correct(guess)}
      end

    {:reply, {atom, response}, state}
  end

  defp maybe_debug(msg, state) do
    if state.debug, do: Logger.info(msg <> " " <> inspect(state))
  end

  defp fetch_question(state, new) do
    case Logic.question(state, new) do
      {:error, state} -> {:error, state, @error_fetching_question}
      {atom, state} -> {atom, state, Logic.compose_full_question(state)}
    end
  end
end
