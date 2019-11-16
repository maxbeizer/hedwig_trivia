defmodule HedwigTrivia.Fetchers.API do
  @moduledoc """
  A module to provide an interface to call the trivia API.
  """

  @http Application.get_env(:hedwig_trivia, :http)

  @doc """
  Get a random question/answer from the API and return all the data.
  """
  @spec fetch_random() :: {:ok | :error, map()}
  def fetch_random do
    with {:ok, %{body: [res]}} <- @http.get("") do
      {:ok, res}
    else
      {:error, res} ->
        {:error, res}
    end
  end
end
