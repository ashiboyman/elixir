defmodule TaskManager3.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManager3.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: :todo,
        title: "some title"
      })
      |> TaskManager3.Tasks.create_task()

    task
  end
end
