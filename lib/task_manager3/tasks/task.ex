defmodule TaskManager3.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :status, Ecto.Enum, values: [:todo, :doing, :done]
    field :description, :string
    field :title, :string
    field :position, :integer, default: 0
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :status])
    |> validate_required([:title, :description, :status])
  end
end
