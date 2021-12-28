defmodule ThumbsDownWeb.PageController do
  use ThumbsDownWeb, :controller
  require Logger
  alias ThumbsDown.Games

  def index(conn, _params) do
    games = Games.top_10()
    open_games = Games.open_games()
    render(conn, "index.html",
      games: games,
      open_games: open_games,
      base_url: System.get_env("BASE_URL")
    )
  end
end
