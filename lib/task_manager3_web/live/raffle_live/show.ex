defmodule TaskManager3Web.RaffleLive.Show do
  use TaskManager3Web, :live_view

  alias TaskManager3.Raffles

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:raffle, Raffles.get_raffle!(id))}
  end

  defp page_title(:show), do: "Show Raffle"
  defp page_title(:edit), do: "Edit Raffle"
end
