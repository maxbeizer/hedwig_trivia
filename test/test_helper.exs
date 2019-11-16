defmodule HedwigTrivia.RobotCase do
  use ExUnit.CaseTemplate

  using responders: responders do
    quote do
      use Hedwig.RobotCase

      @moduletag start_robot: true,
                 name: "hedwig",
                 responders: unquote(responders),
                 capture_log: true
    end
  end
end

ExUnit.start()
