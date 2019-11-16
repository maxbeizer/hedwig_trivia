defmodule HedwigTrivia.AnswerTest do
  use ExUnit.Case, async: true

  alias HedwigTrivia.{
    Answer
  }

  describe "correct_or_close_enough?/2" do
    test """
    When the guess is close enough, return true
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
        assert Answer.correct_or_close_enough?(answer, guess)
      end)
    end

    test """
    When the guess is not close enough, return false[]
    """ do
      [
        {"Franklin", "asdfasdfasdf"}
      ]
      |> Enum.each(fn {answer, guess} ->
        refute Answer.correct_or_close_enough?(answer, guess)
      end)
    end
  end
end
