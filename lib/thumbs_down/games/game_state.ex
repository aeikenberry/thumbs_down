defmodule ThumbsDown.GameState do
  @moduledoc """
  Simple genserver to represent an imaginary game process.
  Requires you provide an integer-based `game_id` upon starting.
  There is a `:fetch_data` callback handler where you could easily get additional game attributes
  from a database or some other source - assuming the `game_id` provided was a valid key to use as
  database criteria.
  """

  use GenServer
  require Logger

  @game_registry_name :game_registry
  @process_lifetime_ms 86_400_000 # 24 hours in milliseconds - make this number shorter to experiement with process termination

  # Just a simple struct to manage the state for this genserver
  # You could add additional attributes here to keep track of for a given game
  defstruct game_id: 0,
            start_time: nil,
            end_time: nil,
            timer_ref: nil,
            users: [],
            in_progress: false,
            winner: nil,
            duration: nil


  @doc """
  Starts a new game process for a given `game_id`.
  """
  def start_link(game_id) when is_integer(game_id) do
    GenServer.start_link(__MODULE__, [game_id], name: via_tuple(game_id))
  end


  # registry lookup handler
  defp via_tuple(game_id), do: {:via, Registry, {@game_registry_name, game_id}}


  @doc """
  Return some details (state) for this game process
  """
  def details(game_id) do
    GenServer.call(via_tuple(game_id), :get_details)
  end


  @doc """
  Returns the pid for the `game_id` stored in the registry
  """
  def whereis(game_id) do
    case Registry.lookup(@game_registry_name, game_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def start_game(game_id) do
    GenServer.call(via_tuple(game_id), :start_game)
  end

  def end_game(game_id) do
    GenServer.call(via_tuple(game_id), :end_game)
  end

  def set_users(game_id, users) do
    GenServer.call(via_tuple(game_id), {:set_users, users})
  end

  def track_event(game_id, event) do
    GenServer.call(via_tuple(game_id), {:track_event, event})
  end

  def set_winner(game_id, username) do
    GenServer.call(via_tuple(game_id), {:set_winner, username})
  end

  def set_duration(game_id, duration) do
    GenServer.call(via_tuple(game_id), {:set_duration, duration})
  end

  def set(game_id, game) do
    GenServer.call(via_tuple(game_id), {:set, game})
  end

  @doc """
  Init callback
  """
  def init([game_id]) do

    # Add a msg to the process mailbox to
    # tell this process to run `:fetch_data`
    # send(self(), :fetch_data)
    send(self(), :set_terminate_timer)

    Logger.info("Process created... game ID: #{game_id}")

    # Set initial state and return from `init`
    {:ok, %__MODULE__{ game_id: game_id }}
  end


  @doc """
  Callback handler that sets a timer for 24 hours to terminate this process.
  You can call this more than once it will continue to `push out` the timer (and cleans up the previous one)
  I could have combined the logic below and used just one callback handler, but I like seperating the
  concern of creating an initial timer reference versus destroying an existing one. But that is up to you.
  """
  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: nil } = state) do
    # This is the first time we've dealt with this game, so lets set our timer reference attribute
    # to end this process in 24 hours from now

    # set a timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end
  def handle_info(:set_terminate_timer, %__MODULE__{ timer_ref: timer_ref } = state) do
    # This match indicates we are in a situation where `state.timer_ref` is not nil -
    # so we already have dealt with this game before

    # let's cancel the existing timer
    timer_ref |> Process.cancel_timer

    # set a new timer for 24 hours from now to end this process
    updated_state =
      %__MODULE__{ state | timer_ref: Process.send_after(self(), :end_process, @process_lifetime_ms) }

    {:noreply, updated_state}
  end
  def handle_info(:end_process, state) do
    Logger.info("Process terminating... game ID: #{state.game_id}")
    {:stop, :normal, state}
  end


  @doc false
  def handle_call(:get_details, _from, state) do

    response = %{
      id: state.game_id,
      start_time: state.start_time,
      end_time: state.end_time,
      users: state.users,
      is_started: state.start_time != nil,
      is_ended: state.end_time != nil,
      in_progress: state.start_time != nil && state.end_time == nil,
      winner: state.winner,
      duration: state.duration
    }

    {:reply, response, state}
  end

  def handle_call({:set_users, users}, _from, state) do
    {:reply, :ok, %__MODULE__{ state | users: users}}
  end

  def handle_call({:set_winner, username}, _from, state) do
    {:reply, :ok, %__MODULE__{ state | winner: username }}
  end

  @doc false
  def handle_call(:start_game, _from, state) do
    {:reply, :ok, %__MODULE__{ state | start_time: DateTime.utc_now}}
  end

  def handle_call(:end_game, _from, state) do
    {:reply, :ok, %__MODULE__{ state | end_time: DateTime.utc_now}}
  end

  def handle_call({:set_duration, duration}, _from, state) do
    {:reply, :ok, %__MODULE__{ state | duration: duration }}
  end

  def handle_call({:set, game}, _from, _) do
    {:reply, :ok, %__MODULE__{
      users: game.users,
      start_time: game.start_time,
      end_time: game.end_time,
      winner: game.winner,
      duration: game.duration
    }}
  end

end
