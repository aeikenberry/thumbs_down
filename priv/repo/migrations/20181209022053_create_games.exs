defmodule ThumbsDown.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :room_id, :string
      add :start_time, :date
      add :end_time, :date
      add :starting, :boolean, default: true
      add :users, :map

      timestamps()
    end

  end
end
