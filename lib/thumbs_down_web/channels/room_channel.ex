defmodule ThumbsDownWeb.RoomChannel do
    use Phoenix.Channel
    alias ThumbsDown.Presence
    alias ThumbsDown.Games.Manager
    require Logger

    def join("room:" <> game_room_id, params, socket) do
      # Check if there is an active game in the database

      # If not, they can join.
      socket = assign(socket, :room_id, game_room_id)
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
      Logger.info(Manager.all_thumbs_down(Presence.list(socket)))
      {:reply, :ok, socket}
    end
  end