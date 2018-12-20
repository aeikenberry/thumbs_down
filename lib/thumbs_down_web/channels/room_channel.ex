defmodule ThumbsDownWeb.RoomChannel do
  use Phoenix.Channel
  alias ThumbsDown.Presence
  alias ThumbsDown.GameManager

  require Logger

  def join("room:" <> game_id, params, socket) do
    {game_room_int, _} = Integer.parse(game_id)

    socket = assign(socket, :game_id, game_room_int)
    send(self(), :after_join)

    {:ok, assign(socket, :name, params["name"])}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", Presence.list(socket))

    GameManager.ensure_state(socket.assigns.game_id)

    {:ok, _} = Presence.track(socket, socket.assigns.name, %{
      thumb_down: false,
    })

    :ok = ThumbsDown.ChannelWatcher.monitor(
      :rooms, self(), {__MODULE__, :leave, [
        socket.assigns.game_id,
        socket.assigns.name,
        socket
      ]}
    )

    game = GameManager.get(socket.assigns.game_id)
    broadcast(socket, "game_update", game)

    {:noreply, socket}
  end

  def leave(game_id, user_name, socket) do
    GameManager.handle_leave(game_id, user_name, Presence.list(socket))
  end

  def handle_in("thumb_change", attrs, socket) do
    Presence.update(socket, socket.assigns.name, %{thumb_down: attrs["is_down"]})
    game = GameManager.handle_change(
      socket.assigns.game_id,
      Presence.list(socket),
      %{
        user: socket.assigns.name,
        thumb_down: attrs["is_down"]
      }
    )
    broadcast(socket, "game_update", game)

    {:reply, :ok, socket}
  end
end
