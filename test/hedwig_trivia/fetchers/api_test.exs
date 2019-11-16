defmodule HedwigTrivia.Fetchers.APITest do
  use ExUnit.Case

  alias HedwigTrivia.Fetchers.API

  describe "get_random/0" do
    test "happy path" do
      {atom, data} = API.fetch_random()

      keys = [
        "airdate",
        "answer",
        "category",
        "category_id",
        "created_at",
        "game_id",
        "id",
        "invalid_count",
        "question",
        "updated_at",
        "value"
      ]

      assert :ok == atom

      Enum.each(keys, fn key ->
        assert key in Map.keys(data)
      end)
    end
  end
end
