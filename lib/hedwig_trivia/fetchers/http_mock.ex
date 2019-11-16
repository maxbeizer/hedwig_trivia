defmodule HedwigTrivia.Fetchers.HTTPMock do
  @moduledoc """
  HTTP module for mocking the HTTP module to talk with the trivia API.
  """

  @doc false
  def get("") do
    {:ok,
     %HTTPoison.Response{
       body: [
         %{
           "airdate" => "2006-11-28T12:00:00.000Z",
           "answer" => "vegetarian",
           "category" => %{
             "clues_count" => 15,
             "created_at" => "2014-02-11T22:47:28.802Z",
             "id" => 70,
             "title" => "ben franklin",
             "updated_at" => "2014-02-11T22:47:28.802Z"
           },
           "category_id" => 70,
           "created_at" => "2014-02-11T23:40:12.600Z",
           "game_id" => nil,
           "id" => 81_610,
           "invalid_count" => nil,
           "question" =>
             "At 16 Ben read a book by Thomas Tryon & accordingly adopted this type of diet",
           "updated_at" => "2014-02-11T23:40:12.600Z",
           "value" => 400
         }
       ]
     }}
  end
end
