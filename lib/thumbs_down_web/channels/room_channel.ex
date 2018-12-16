defmodule ThumbsDownWeb.RoomChannel do
    use Phoenix.Channel
    alias ThumbsDown.Presence
    alias ThumbsDown.Games
    alias ThumbsDown.Games.Manager
    alias ThumbsDown.GameSupervisor
    alias ThumbsDown.GameServer
    require Logger

    def join("room:" <> game_room_id, params, socket) do
      {game_room_int, _} = Integer.parse(game_room_id)
      GameSupervisor.find_or_create_process(game_room_int)
      # If not, they can join.
      socket = assign(socket, :room_id, game_room_int)
      send(self(), :after_join)

      {:ok, assign(socket, :name, params["name"])}
    end

    def handle_info(:after_join, socket) do
      push(socket, "presence_state", Presence.list(socket))
      {:ok, _} = Presence.track(socket, socket.assigns.name, %{
        thumb_down: false,
      })
      {:noreply, socket}
    end

    def handle_in("thumb_change", attrs, socket) do
      Presence.update(socket, socket.assigns.name, %{thumb_down: attrs["is_down"]})
      all_thumbs_down = Manager.all_thumbs_down(Presence.list(socket))

      if (all_thumbs_down) do
        GameServer.start_game(socket.assigns.room_id)
        Logger.info(inspect(GameServer.details(socket.assigns.room_id)))
      end
      {:reply, :ok, socket}
    end
  end
