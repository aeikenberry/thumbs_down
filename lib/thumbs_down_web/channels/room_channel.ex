defmodule ThumbsDownWeb.RoomChannel do
    use Phoenix.Channel
    alias ThumbsDown.Presence
    require Logger
  
    def join("room:" <> _game_room_id, params, socket) do
      send(self(), :after_join)
      {:ok, assign(socket, :name, params["name"])}
    end

    def handle_info(:after_join, socket) do
      push(socket, "presence_state", Presence.list(socket))
      {:ok, _} = Presence.track(socket, socket.assigns.name, %{
        online_at: inspect(System.system_time(:second)),
        thumb_down: false
      })
      {:noreply, socket}
    end

    def handle_in("thumb_change", attrs, socket) do
      Presence.update(socket, socket.assigns.name, %{thumb_down: attrs["is_down"]})
      {:reply, :ok, socket}
    end
  end