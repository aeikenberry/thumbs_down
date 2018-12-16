defmodule ThumbsDown.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :duration, :float
    field :end_time, :naive_datetime
    field :room_id, :string
    field :start_time, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:room_id, :start_time, :end_time, :duration])
    |> validate_required([:room_id])
  end
end
