defmodule ThumbsDown.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :room_id, :string
      add :start_time, :naive_datetime, null: true
      add :end_time, :naive_datetime, null: true
      add :duration, :float, null: true

      timestamps()
    end

  end
end
