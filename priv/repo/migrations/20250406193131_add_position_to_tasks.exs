defmodule TaskManager3.Repo.Migrations.AddPositionToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :position, :integer, default: 0, null: false
    end
  end
end
