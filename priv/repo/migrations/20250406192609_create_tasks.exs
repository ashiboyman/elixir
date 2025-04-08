defmodule TaskManager3.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :description, :text
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
