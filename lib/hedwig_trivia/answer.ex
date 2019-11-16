defmodule HedwigTrivia.Answer do
  @moduledoc """
  Logic surrounding determining if the supplied answer is correct
  """
  @minimum_guess_distance 0.8
  @articles_to_be_replaced [
    "the ",
    "a "
  ]

  @doc """
  Is the supplied answer close enough to the answer from the API?
  """
  @spec correct_or_close_enough?(String.t(), String.t()) :: boolean()
  def correct_or_close_enough?(answer, guess) do
    with downed_guess <- String.downcase(guess),
         downed_answer <- String.downcase(answer),
         [downed_answer, downed_guess] <-
           maybe_trim_leading_article(downed_answer, downed_guess) do
      downed_answer == downed_guess || close_enough(downed_answer, downed_guess)
    end
  end

  defp close_enough(answer, guess) do
    String.jaro_distance(answer, guess) > @minimum_guess_distance
  end

  defp maybe_trim_leading_article(answer, guess) do
    [replace_article(answer, guess), guess]
  end

  defp replace_article(answer, guess) do
    Enum.reduce(@articles_to_be_replaced, answer, fn article_string, acc ->
      if article_needs_replacing?(answer, guess, article_string) do
        String.replace_prefix(acc, article_string, "")
      else
        acc
      end
    end)
  end

  defp article_needs_replacing?(answer, guess, article_string) do
    String.starts_with?(answer, article_string) &&
      !String.starts_with?(guess, article_string)
  end
end
