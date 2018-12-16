defmodule ThumbsDown.GameSupervisor do
  @moduledoc """
  Supervisor to handle the creation of dynamic `RegistrySample.game` processes using a
  `simple_one_for_one` strategy. See the `init` callback at the bottom for details on that.
  These processes will spawn for each `game_id` provided to the
  `RegistrySample.game.start_link` function.
  Functions contained in this supervisor module will assist in the creation and retrieval of
  new game processes.
  Also note the guards utilizing `is_integer(game_id)` on the functions. My feeling here is that
  if someone makes a mistake and tries sending a string-based key or an atom, I'll just _"let it crash"_.
  """

  use Supervisor
  require Logger


  @game_registry_name :game_registry

  @doc """
  Starts the supervisor.
  """
  def start_link, do: Supervisor.start_link(__MODULE__, [], name: __MODULE__)


  @doc """
  Will find the process identifier (in our case, the `game_id`) if it exists in the registry and
  is attached to a running `RegistrySample.game` process.
  If the `game_id` is not present in the registry, it will create a new `RegistrySample.game`
  process and add it to the registry for the given `game_id`.
  Returns a tuple such as `{:ok, game_id}` or `{:error, reason}`
  """
  def find_or_create_process(game_id) when is_integer(game_id) do
    if game_process_exists?(game_id) do
      {:ok, game_id}
    else
      game_id |> create_game_process
    end
  end


  @doc """
  Determines if a `RegistrySample.game` process exists, based on the `game_id` provided.
  Returns a boolean.
  ## Example
      iex> RegistrySample.gameSupervisor.game_process_exists?(6)
      false
  """
  def game_process_exists?(game_id) when is_integer(game_id) do
    case Registry.lookup(@game_registry_name, game_id) do
      [] -> false
      _ -> true
    end
  end


  @doc """
  Creates a new game process, based on the `game_id` integer.
  Returns a tuple such as `{:ok, game_id}` if successful.
  If there is an issue, an `{:error, reason}` tuple is returned.
  """
  def create_game_process(game_id) when is_integer(game_id) do
    case Supervisor.start_child(__MODULE__, [game_id]) do
      {:ok, _pid} -> {:ok, game_id}
      {:error, {:already_started, _pid}} -> {:error, :process_already_exists}
      other -> {:error, other}
    end
  end


  @doc """
  Returns the count of `RegistrySample.game` processes managed by this supervisor.
  ## Example
      iex> RegistrySample.gameSupervisor.game_process_count
      0
  """
  def game_process_count, do: Supervisor.which_children(__MODULE__) |> length


  @doc """
  Return a list of `game_id` integers known by the registry.
  ex - `[1, 23, 46]`
  """
  def game_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, game_proc_pid, _, _} ->
      Registry.keys(@game_registry_name, game_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end



  @doc false
  def init(_) do
    children = [
      worker(ThumbsDown.GameServer, [], restart: :temporary)
    ]

    # strategy set to `:simple_one_for_one` to handle dynamic child processes.
    supervise(children, strategy: :simple_one_for_one)
  end

end