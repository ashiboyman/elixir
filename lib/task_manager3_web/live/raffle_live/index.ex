defmodule TaskManager3Web.RaffleLive.Index do
  use TaskManager3Web, :live_view

  alias TaskManager3.Raffles
  alias TaskManager3.Raffles.Raffle

  @impl true
  def mount(_params, _session, socket) do
    form = to_form(%{})
    socket = socket |> assign(:form, form)
    {:ok, stream(socket, :raffles, Raffles.list_raffles())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Raffle")
    |> assign(:raffle, Raffles.get_raffle!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Raffle")
    |> assign(:raffle, %Raffle{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Raffles")
    |> assign(:raffle, nil)
  end

  @impl true
  def handle_info({TaskManager3Web.RaffleLive.FormComponent, {:saved, raffle}}, socket) do
    {:noreply, stream_insert(socket, :raffles, raffle)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Raffles.get_raffle!(id)
    {:ok, _} = Raffles.delete_raffle(raffle)

    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  def handle_event("filter", params, socket) do
    socket =
      socket
      |> assign(:form, to_form(params))
      |> stream(:raffles, Raffles.filter_raffles(params), reset: true)

    {:noreply, socket}
  end


  attr :raffle, TaskManager3.Raffles.Raffle, required: true
  attr :id, :string, required: true

  def raffle_card(assigns) do
    ~H"""
    <.link navigate={~p"/raffles/#{@raffle}"} id={@id}>
      <div class="card">

        <img src={@raffle.image_path} />
        <h2>{@raffle.prize}</h2>
        <div class="details">
          <div class="price">
            ${@raffle.ticket_price} / ticket
          </div>
          <.badge status={@raffle.status} />
        </div>
      </div>
    </.link>
    """
  end

  def badge(assigns) do
    ~H"""
    <div class={[
      "rounded-md px-2 py-1 text-xs font-medium uppercase inline-block border",
      @status == :open && "text-lime-600 border-lime-600",
      @status == :upcoming && "text-amber-600 border-amber-600",
      @status == :closed && "text-gray-600 border-gray-600",
    ]}>
      {@status}
    </div>
    """
  end
end
