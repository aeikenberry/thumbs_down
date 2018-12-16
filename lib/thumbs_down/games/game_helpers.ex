defmodule ThumbsDown.Games.Manager do
  def all_thumbs_down(users) do
    count = Enum.count(users)
    down_count = Enum.count(users, fn {name,value} ->
      Enum.at(value[:metas], 0)[:thumb_down] == true
    end)
    count == down_count
  end

  def game_in_progress(game_room) do
    ThumbsDown.Games.get_by(game_room)
  end
end
