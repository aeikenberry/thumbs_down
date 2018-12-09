defmodule ThumbsDown.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :room_id, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:room_id])
    |> validate_required([:room_id])
  end
end
