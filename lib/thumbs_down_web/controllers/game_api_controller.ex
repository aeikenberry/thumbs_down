defmodule ThumbsDownWeb.GameAPIController do
  use ThumbsDownWeb, :controller

  alias ThumbsDown.Games
  alias ThumbsDown.Games.Game

  def index(conn, _params) do
    games = Games.list_games()
    render(conn, "index.json", games: games)
  end

  def create(conn, _game_params) do
    case Games.create_game(_game_params) do
      {:ok, game} ->
        render(conn, "game.json", game: game)
    end
  end

  def show(conn, %{"id" => id}) do
    game = Games.get_game!(id)
    render(conn, "game.json", game: game)
  end
end
