defmodule HedwigTrivia.RespondersTest do
  @moduledoc false

  use HedwigTrivia.RobotCase,
    responders: [{HedwigTrivia.Responders, []}]

  test "trivia", %{adapter: adapter, msg: msg} do
    send(adapter, {:message, %{msg | text: "hedwig trivia"}})
    assert_receive {:message, %{text: text}}
    assert "mock question" == text
  end

  test "trivia!", %{adapter: adapter, msg: msg} do
    send(adapter, {:message, %{msg | text: "hedwig trivia!"}})
    assert_receive {:message, %{text: text}}
    assert "mock force new question" == text
  end

  test "guess correctly", %{adapter: adapter, msg: msg} do
    send(adapter, {:message, %{msg | text: "hedwig guess correct"}})
    assert_receive {:message, %{text: text}}
    assert "correct" == text
  end

  test "guess incorrectly", %{adapter: adapter, msg: msg} do
    send(adapter, {:message, %{msg | text: "hedwig guess incorrect"}})
    assert_receive {:message, %{text: text}}
    assert "incorrect" == text
  end

  test "solution/0", %{adapter: adapter, msg: msg} do
    send(adapter, {:message, %{msg | text: "hedwig solution"}})
    assert_receive {:message, %{text: text}}
    assert "solution" == text
  end
end
