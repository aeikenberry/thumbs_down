defmodule ThumbsDownWeb.PageController do
  use ThumbsDownWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
