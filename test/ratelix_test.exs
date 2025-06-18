defmodule RatelixTest do
  use ExUnit.Case
  doctest Ratelix

  test "greets the world" do
    assert Ratelix.hello() == :world
  end
end
