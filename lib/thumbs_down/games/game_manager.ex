defmodule ThumbsDown.GameManager do
  alias ThumbsDown.GameSupervisor
  alias ThumbsDown.GameState
  require Logger

  ## Helpers

  def all_thumbs_down?(users) do
    count = Enum.count(users)
    down = down_count(users)
    count == down
  end

  def down_count(users) do
    Enum.count(users, fn {name,value} ->
      Enum.at(value[:metas], 0)[:thumb_down] == true
    end)
  end

  def find_winner(game, user_state, username_exitting) do
    c = Enum.count(user_state)
    case c do
      1 -> Enum.at(Map.keys(user_state), 0)
      0 -> username_exitting
    end
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

  def set_winner(id, username) do
    GameState.set_winner(id, username)
  end

  def track_event(id, event) do
    GameState.track_event(id, event)
  end

  ## Game State Supervisor API
  def ensure_state(id) do
    GameSupervisor.find_or_create_process(id)
  end

  ## Handlers
  def handle_change(id, user_state, %{thumb_down: true} = change) do
    game_current = get(id)

    handle_thumb_down(game_current, user_state, change[:user])

    get(id)
  end

  def handle_change(id, user_state, %{thumb_down: false} = change) do
    game_current = get(id)

    handle_thumb_up(game_current, user_state, change[:user])

    get(id)
  end

  def handle_thumb_up(%{in_progress: false} = game, user_state, username) do
    # Noop who cares!
  end

  def handle_thumb_up(%{in_progress: true} = game, user_state, username) do
    # Someone is out!
    down = down_count(user_state)
    if Enum.count(user_state) <= 1 do
      end_game(game.id)
      set_winner(game.id, find_winner(game, user_state, username))
    end
  end

  def handle_thumb_down(%{in_progress: false} = game, user_state, username) do
    # Is everyone down?
    ## Yes: Start the game!
    ## No: noop

    if all_thumbs_down?(user_state) do
      start_game(game.id)
      set_users(game.id, user_state)
    end
  end

  def handle_thumb_down(%{in_progress: true} = game, user_state, username) do
    # Thumb Down while game is running doesn't make sense, do nothing
    Logger.info("Thumb Down while game is running doesn't make sense, do nothing")
  end

  def handle_leave(id, user_leaving, user_state) do
    game = get(id)
    handle_thumb_up(game, user_state, user_leaving)
  end
end
