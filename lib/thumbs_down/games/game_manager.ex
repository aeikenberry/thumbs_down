defmodule ThumbsDown.GameManager do
  alias ThumbsDown.GameSupervisor
  alias ThumbsDown.GameState
  require Logger

  ## Helpers

  def all_thumbs_down?(users) do
    count = Enum.count(users)
    down_count = Enum.count(users, fn {name,value} ->
      Enum.at(value[:metas], 0)[:thumb_down] == true
    end)
    count == down_count
  end

  def usernames(users) do
    Map.keys(users)
  end

  ## Game state API
  def set_users(id, user_state) do
    GameState.set_users(id, usernames(user_state))
  end

  def get(id) do
    GameState.details(id)
  end

  def start_game(id) do
    GameState.start_game(id)
  end

  def end_game(id) do
    GameState.end_game(id)
  end

  def track_event(id, event) do
    GameState.track_event(id, event)
  end

  ## Game State Supervisor API
  def ensure_state(id) do
    GameSupervisor.find_or_create_process(id)
  end

  ## Handlers
  def handle_change(id, user_state, change) do
    track_event(id, change)
    all_thumbs_down = all_thumbs_down?(user_state)
    game_current = get(id)

    if (all_thumbs_down && !game_current.is_started) do
      start_game(id)
      set_users(id, user_state)
    end

    if (!all_thumbs_down && game_current.is_started) do
      end_game(id)
    end

    get(id)
  end

  def handle_leave(id, user) do
    Logger.info(id)
    Logger.info(user)
  end
end
