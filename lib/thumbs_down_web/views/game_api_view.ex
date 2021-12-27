defmodule ThumbsDownWeb.GameAPIView do
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
    base_url = System.get_env("BASE_URL")

    %{
      id: game.id,
      users: game.users,
      winner: game.winner,
      duration: game.duration,
      start_time: game.start_time,
      end_time: game.end_time,
      game_url: "#{base_url}/games/#{game.id}"
    }
  end
end
