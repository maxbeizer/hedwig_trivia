defmodule HedwigTrivia.GameState do
  @moduledoc """
  The home of the game state shape of HedwigTrivia
  """

  defstruct question: "",
            answer: "",
            category_name: "",
            value: 0,
            answered: true,
            debug: false

  @type question :: String.t()
  @type answer :: String.t()
  @type category_name :: String.t()
  @type value :: integer()
  @type answered :: boolean()
  @type debug :: boolean()
  @type t :: %__MODULE__{
          question: question,
          answer: answer,
          category_name: category_name,
          value: value,
          answered: answered,
          debug: debug
        }

  @doc """
  Merge the pased in configuration with the defaults to create the Config
  struct.
  """
  @spec new(map()) :: t()
  def new(passed_in \\ %{}) do
    struct(__MODULE__, passed_in)
  end
end
