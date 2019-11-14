defmodule HedwigTriviaTest do
  use ExUnit.Case
  doctest HedwigTrivia

  test "greets the world" do
    assert HedwigTrivia.hello() == :world
  end
end
