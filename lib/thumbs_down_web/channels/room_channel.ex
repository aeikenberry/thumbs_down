defmodule ThumbsDownWeb.RoomChannel do
    use Phoenix.Channel
    alias ThumbsDown.Presence
  
    def join("room:" <> _game_room_id, params, socket) do
      send(self(), :after_join)
      {:ok, assign(socket, :name, params["name"])}
    end

    def handle_info(:after_join, socket) do
      push(socket, "presence_state", Presence.list(socket))
      {:ok, _} = Presence.track(socket, socket.assigns.name, %{
        online_at: inspect(System.system_time(:second))
      })
      {:noreply, socket}
    end
  end