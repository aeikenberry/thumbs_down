defmodule ThumbsDownWeb.GameView do
  use ThumbsDownWeb, :view

  def render("index.json", %{games: games}) do
    %{
      games: Enum.map(games, &game_json/1)
    }
  end
  def render("game.json", %{game: game}) do
    game_json(game)
  end

  def game_json(game) do
    %{
      id: game.id
    }
  end
end
