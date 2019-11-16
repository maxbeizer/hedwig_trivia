defmodule HedwigTrivia.QuestionTest do
  use ExUnit.Case, async: true

  alias HedwigTrivia.{
    GameState,
    Question
  }

  doctest Question

  describe "fetch/2" do
    test "happy path" do
      {atom, res} = Question.fetch(GameState.new(), __MODULE__.APIHappy)
      assert :ok == atom
      assert "question" == res.question
    end

    test "api error" do
      starting_state = GameState.new()
      {atom, res} = Question.fetch(starting_state, __MODULE__.APISad)
      assert :error == atom
      assert starting_state == res
    end
  end

  describe "strip_html/1" do
    test """
    when answer has italics tags, the tags are removed
    """ do
      assert "Answer" == Question.strip_html("<i>Answer</i>")
    end

    test """
    when answer has underline tags, the tags are removed
    """ do
      assert "Answer" == Question.strip_html("<u>Answer</u>")
    end
  end

  describe "check_worthiness/1" do
    test """
    when question is "=", returns :error
    """ do
      assert :bad ==
               Question.check_worthiness(%{
                 "question" => "=",
                 "answer" => "asdf"
               })
    end

    test """
    when answer is "=", returns :error
    """ do
      assert :bad ==
               Question.check_worthiness(%{
                 "question" => "asdf",
                 "answer" => "="
               })
    end

    test """
    when neither question nor answer is "=", returns :ok
    """ do
      assert :ok ==
               Question.check_worthiness(%{
                 "question" => "asdf",
                 "answer" => "asdf"
               })
    end
  end

  defmodule APIHappy do
    def fetch_random do
      {:ok,
       %{
         "question" => "question",
         "answer" => "answer",
         "category" => %{"title" => "category"},
         "value" => "value"
       }}
    end
  end

  defmodule APISad do
    def fetch_random do
      {:error,
       %{
         "question" => "question",
         "answer" => "answer",
         "category" => %{"title" => "category"},
         "value" => "value"
       }}
    end
  end
end
