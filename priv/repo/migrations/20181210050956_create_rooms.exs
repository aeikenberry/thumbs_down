defmodule ThumbsDown.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :room_id, :string, unique: true
      timestamps()
    end

  end
end
