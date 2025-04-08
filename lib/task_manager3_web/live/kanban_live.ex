defmodule TaskManager3Web.KanbanLive do
  use TaskManager3Web, :live_view
  alias TaskManager3.Tasks

  @statuses [:todo, :doing, :done]

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Phoenix.PubSub.subscribe(TaskManager3.PubSub, "tasks")
    tasks = Tasks.list_tasks()
    {:ok, assign(socket, tasks: tasks, statuses: @statuses)}
  end

  @impl true
  def handle_event("update_status", %{"id" => id, "status" => new_status}, socket) do
    task = Tasks.get_task!(id)
    status_atom = String.to_existing_atom(new_status)

    case Tasks.update_task(task, %{status: status_atom}) do
      {:ok, updated_task} ->
        # Broadcast to other clients
        Phoenix.PubSub.broadcast(TaskManager3.PubSub, "tasks", {:status_updated, updated_task})

        # Send update back to this client for immediate UI update
        {:noreply, push_event(socket, "task_updated", %{
          id: updated_task.id,
          status: new_status
        })}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  @impl true
  def handle_info({:status_updated, updated_task}, socket) do
    # Update the tasks list in our assigns
    {:noreply, update_tasks(socket) |> push_event("task_updated", %{
      id: updated_task.id,
      status: Atom.to_string(updated_task.status)
    })}
  end

  defp update_tasks(socket) do
    tasks = Tasks.list_tasks()
    assign(socket, tasks: tasks)
  end
end
