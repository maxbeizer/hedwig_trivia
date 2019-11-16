defmodule HedwigTrivia.LogicTest do
  use ExUnit.Case, async: true

  alias HedwigTrivia.{
    Logic,
    GameState
  }

  describe "question/2" do
    test """
    when the current question has not yet been answered and a new question is
    not being forced, return a not_answered tuple
    """ do
      game_state =
        new_game_state(%{answered: false, question: "not yet answered"})

      {atom, res} = Logic.question(game_state, false)
      assert :not_answered == atom
      assert game_state == res
    end

    test """
    when the current question has been answered and a new question is not
    being forced, return an ok tuple
    """ do
      game_state = new_game_state(%{answered: true, question: "answered"})
      {atom, state} = Logic.question(game_state, false)
      assert :ok == atom
      refute state.answered
    end

    test """
    when a new question is being forced, return fetch a new question and set
    the state
    """ do
      game_state = new_game_state()
      # default state
      assert game_state.answered
      {atom, state} = Logic.question(game_state, true)
      assert :ok == atom
      refute state.answered
    end
  end

  describe "guess/2" do
    test """
    When guess is exactly the right answer, return ok tuple with updated state
    """ do
      game_state = new_game_state(%{answered: false, answer: "correct answer"})
      {atom, state} = Logic.guess(game_state, "correct answer")
      assert :ok == atom
      assert state.answered
    end

    test """
    When guess is not even close, return error tuple with unchanged state
    """ do
      game_state = new_game_state(%{answered: false, answer: "correct answer"})
      {atom, state} = Logic.guess(game_state, "asdfasdfasdfasdf")
      assert :error == atom
      assert state == game_state
    end

    test """
    When the question has already been answered, return an already_answered
    tuple and state
    """ do
      game_state = new_game_state(%{answered: true})
      {atom, state} = Logic.guess(game_state, "asdfasdfasdfasdf")
      assert :already_answered == atom
      assert state == game_state
    end

    test """
    When the guess is close enough, return an ok tuple with updated state
    """ do
      [
        {"Franklin", "Frnaklin"},
        {"Franklin", "frnaklin"},
        {"Franklin", "FRNAKLIN"},
        {"Franklin", "Frnalkin"},
        {"Dwayne", "Duane"},
        {"Dwayne", "Dawn"},
        {"Dwayne", "Dwanye"},
        {"the heart", "heart"},
        {"a key", "key"}
      ]
      |> Enum.each(fn {answer, guess} ->
        game_state = new_game_state(%{answered: false, answer: answer})
        {atom, state} = Logic.guess(game_state, guess)
        assert :ok == atom
        assert state.answered
      end)
    end
  end

  describe "solution/1" do
    test """
    it returns an ok tuple and sets answered to true
    """ do
      game_state = new_game_state(%{answer: "too hard", answered: false})
      {atom, state} = Logic.solution(game_state)
      assert :ok == atom
      assert state.answered
    end

    test """
    when the game state has an empty answer, it returns an error tuple
    """ do
      game_state = new_game_state(%{answer: ""})
      {atom, state} = Logic.solution(game_state)
      assert :error == atom
      assert state == game_state
    end

    test """
    when the game state doesn't have an answer, it returns an error tuple
    """ do
      game_state = new_game_state(%{answer: nil})
      {atom, state} = Logic.solution(game_state)
      assert :error == atom
      assert state == game_state
    end
  end

  describe "compose_full_question/1" do
    test """
    builds a question with category and value info
    """ do
      game_state =
        new_game_state(%{
          question: "question",
          category_name: "category",
          value: 100
        })

      expected = "_category_[$100] question"
      assert expected == Logic.compose_full_question(game_state)
    end
  end

  describe "incorrect/1" do
    test "returns a phrase indicating guess is incorrect" do
      assert Logic.incorrect("foo") =~ "foo is incorrect"
    end
  end

  describe "correct/1" do
    test "returns a phrase indicating guess is correct" do
      assert Logic.correct("foo") =~ "foo is correct"
    end
  end

  defp new_game_state(opts \\ %{}), do: GameState.new(opts)
end
