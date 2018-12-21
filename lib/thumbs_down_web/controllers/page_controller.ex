defmodule ThumbsDownWeb.PageController do
  use ThumbsDownWeb, :controller
  require Logger
  alias ThumbsDown.Games

  def index(conn, _params) do
    games = Games.top_10()
    Logger.info(inspect(games))
    render(conn, "index.html", games: games)
  end
end
