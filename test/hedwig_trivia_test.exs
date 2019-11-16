defmodule HedwigTriviaTest do
  use ExUnit.Case, async: true

  alias HedwigTrivia

  alias HedwigTrivia.{
    GameState
  }

  describe "state/0" do
    test "when started with no default, returns fresh game state" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      assert GameState.new() == HedwigTrivia.state()
    end

    test "when started with default, returns game state with defaults" do
      {:ok, _pid} = start_supervised({HedwigTrivia, %{value: 42}})
      result = Map.get(HedwigTrivia.state(), :value)
      assert 42 == result
    end
  end

  describe "question/1" do
    test "when question has not been answered, returns the question" do
      {:ok, _pid} =
        start_supervised(
          {HedwigTrivia,
           %{
             answered: false,
             question: "already posed",
             value: 100,
             category_name: "category"
           }}
        )

      {atom, result} = HedwigTrivia.question()
      assert "_category_[$100] already posed" == result
      assert :not_answered == atom
    end

    test "when question has been answered, returns fetches a new question" do
      {:ok, _pid} =
        start_supervised(
          {HedwigTrivia, %{answered: true, question: "already posed"}}
        )

      {atom, result} = HedwigTrivia.question()
      # see http_mock
      assert result =~ "At 16 Ben"
      assert :ok == atom
    end
  end

  describe "solution/0" do
    test "when no solution exists, it returns an error tuple" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      assert GameState.new() == HedwigTrivia.state()

      {atom, result} = HedwigTrivia.solution()
      assert :error == atom
      assert result =~ "I've lost track of the question"
    end

    test "when no solution exists, it returns an ok tuple with the solution" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      {:ok, _result} = HedwigTrivia.question()

      {atom, result} = HedwigTrivia.solution()
      assert :ok == atom
      # see http_mock
      assert "vegetarian" == result
    end

    test "it fetches a new question" do
      {:ok, _pid} = start_supervised(HedwigTrivia)

      HedwigTrivia.solution()
      result = HedwigTrivia.state()
      assert "vegetarian" == result.answer
    end
  end

  describe "guess/1" do
    test "when guess is incorrect, it returns an error tuple" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      HedwigTrivia.question()
      {atom, result} = HedwigTrivia.guess("no idea")
      assert :error == atom
      assert result =~ "no idea"
    end

    test "when guess is exactly correct, it returns an ok tuple" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      HedwigTrivia.question()
      # see http_mock
      {atom, result} = HedwigTrivia.guess("vegetarian")
      assert :ok == atom
      assert result =~ "vegetarian"
    end

    test "when guess is case insensitive correct, it returns an ok tuple" do
      {:ok, _pid} = start_supervised(HedwigTrivia)
      HedwigTrivia.question()
      # see http_mock
      {atom, result} = HedwigTrivia.guess("VEGETARIAN")
      assert :ok == atom
      assert result =~ "VEGETARIAN"
    end
  end
end
