defmodule HedwigTriviaMock do
  @moduledoc """
  A mock to mock responses from HedwigTrivia
  """

  @doc false
  def question(force \\ false)
  def question(false), do: {:ok, "mock question"}
  def question(true), do: {:ok, "mock force new question"}

  @doc false
  def guess("correct"), do: {:ok, "correct"}
  def guess("incorrect"), do: {:error, "incorrect"}

  @doc false
  def solution, do: {:ok, "solution"}
end
