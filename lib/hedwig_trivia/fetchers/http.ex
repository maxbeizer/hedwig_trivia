defmodule HedwigTrivia.Fetchers.HTTP do
  @moduledoc """
  HTTP module for commuincating with the jservice API:
  http://jservice.io/api/random
  """
  use HTTPoison.Base

  @base_url "http://jservice.io/api/random"

  @impl true
  def process_request_url(path) do
    @base_url <> path
  end

  @impl true
  def process_response_body(body) do
    body
    |> Poison.decode!()
  end
end
