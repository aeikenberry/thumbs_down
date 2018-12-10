defmodule ThumbsDown.Games.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "rooms" do
    field :room_id, :string
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
