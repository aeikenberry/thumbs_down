defmodule ThumbsDown.GameTest do
  use ThumbsDown.ModelCase

  alias ThumbsDown.Game

  @valid_attrs %{display: "some display", key: "some key"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
