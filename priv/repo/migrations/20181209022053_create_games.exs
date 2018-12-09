defmodule ThumbsDown.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :room_id, :string

      timestamps()
    end

  end
end
