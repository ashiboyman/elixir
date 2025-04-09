defmodule TaskManager3Web.EstimatorLive do
  use TaskManager3Web, :live_view

  # mount
  # initilize the state of the live view by assigning values to the socket
  def mount(_params, _session, socket) do
    socket = assign(socket, tickets: 0, price: 3)
    {:ok, socket}
  end

  # render
  # render only get assigns from the socket
  def render(assigns) do
    ~H"""
    <div class="estimator">
      <section>
        <button phx-click="add" phx-value-quantity="5">
          +
        </button>

        <div>
          {@tickets}
        </div>
        *
        <div>
          ${@price}
        </div>
        =
        <div>
          ${@tickets * @price}
        </div>
      </section>

      <form phx-submit="set-price">
        <label>Ticket Price</label> <input type="number" name="price" value={@price} />
      </form>
    </div>
    """
  end

  # handle_event
  # handle evetn gets the hole socket
  def handle_event("add", %{"quantity" => quantity}, socket) do
    tickets = socket.assigns.tickets + String.to_integer(quantity)
    socket = assign(socket, :tickets, tickets)

    {:noreply, socket}
  end

  def handle_event("set-price", %{"price" => price}, socket) do
    socket = assign(socket, :price, String.to_integer(price))

    {:noreply, socket}
  end
end
