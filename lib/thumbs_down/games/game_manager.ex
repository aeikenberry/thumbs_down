defmodule ThumbsDown.GameManager do
  alias ThumbsDown.GameSupervisor
  alias ThumbsDown.GameState
  alias ThumbsDown.Games
  require Logger

  ## Helpers

  def should_begin_game?(user_state) do
    count = Enum.count(user_state)
    down = Enum.count(user_state, fn {_,value} ->
      Enum.at(value[:metas], 0)[:thumb_down] == true
    end)
    count == down
  end

  def should_game_end?(user_state, game_users) do
    down = game_down_count(user_state, game_users)

    if Enum.count(user_state) <= 1 do
      # someone left or it was only one person
      true
    else
      down <= 1
    end
  end

  def game_down_count(user_state, game_users) do
    Enum.count(user_state, fn {name,value} ->
      case Enum.member?(game_users, name) do
        true -> Enum.at(value[:metas], 0)[:thumb_down] == true
        _ -> false
      end
    end)
  end

  def find_winner(game, user_state, username_exitting) do
    c = game_down_count(user_state, game.users)
    with_thumbs_down = Enum.filter(user_state, fn {_, value} -> Enum.at(value[:metas], 0)[:thumb_down] == true end)
    Logger.info(inspect(with_thumbs_down))
    case c do
      1 -> Enum.at(Tuple.to_list(Enum.at(with_thumbs_down, 0)), 0)
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
    # game = Games.get_game(id)
    # TODO: Update game in database
    # Probably not even load game if it's already over.
    # Show link to start a new game
  end

  def set_winner(id, username) do
    GameState.set_winner(id, username)
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

  def handle_thumb_up(%{in_progress: false} = _, _, _) do
    # Noop who cares!
  end

  def handle_thumb_up(%{in_progress: true} = game, user_state, username) do
    # Someone is out!
    if should_game_end?(user_state, game.users) do
      end_game(game.id)
      set_winner(game.id, find_winner(game, user_state, username))
    end
  end

  def handle_thumb_down(%{in_progress: false} = game, user_state, _) do
    # Is everyone down?
    ## Yes: Start the game!
    ## No: noop

    if should_begin_game?(user_state) do
      start_game(game.id)
      set_users(game.id, user_state)
    end
  end

  def handle_thumb_down(%{in_progress: true} = _, _, _) do
    # Thumb Down while game is running doesn't make sense, do nothing
    Logger.info("Thumb Down while game is running doesn't make sense, do nothing")
  end

  def handle_leave(id, user_leaving, user_state) do
    game = get(id)
    handle_thumb_up(game, user_state, user_leaving)
  end
end
