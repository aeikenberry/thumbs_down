defmodule ThumbsDown.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :end_time, :naive_datetime
    field :start_time, :naive_datetime
    field :users, {:array, :string}
    field :winner, :string
    field :duration, :float

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:users, :winner, :start_time, :end_time, :duration])
    |> validate_required([])
  end
end
