defmodule TaskManager3Web.RaffleLive.Index do
  use TaskManager3Web, :live_view

  alias TaskManager3.Raffles

  @impl true
  def mount(_params, _session, socket) do
    # Initial setup
    socket =
      socket
      |> assign(:loading, true)
      # Start with empty posts
      |> assign(:posts, [])
      # Initialize assigns used elsewhere
      |> assign(:my_var, nil)
      # Assign default filter parameters for the initial load
      |> assign(:current_filter_params, %{})

    # Trigger initial data load
    send(self(), :load_posts)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    my_var = :rand.uniform(1000)

    socket =
      socket
      # |> stream(:raffles, Raffles.filter_raffles(params), reset: true)
      |> assign(:form, to_form(params))
      |> assign(:my_var, my_var)

    # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Raffle")
  #   |> assign(:raffle, Raffles.get_raffle!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Raffle")
  #   |> assign(:raffle, %Raffle{})
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Raffles")
    |> assign(:raffle, nil)
  end



  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    raffle = Raffles.get_raffle!(id)
    {:ok, _} = Raffles.delete_raffle(raffle)

    {:noreply, stream_delete(socket, :raffles, raffle)}
  end

  def handle_event("filter", params, socket) do
    socket = assign(socket, :loading, true)

    # Prepare the filter parameters from the event
    filter_params =
      params
      # Use the keys relevant to Raffles.filter_raffles
      |> Map.take(~w(q status))
      |> Map.reject(fn {_, v} -> v == "" end)

    # Store the calculated parameters in the socket assigns
    socket = assign(socket, :current_filter_params, filter_params)

    # Trigger the data loading process
    send(self(), :load_posts)

    # Update the URL immediately (or move this to handle_info if you prefer)
    socket = push_patch(socket, to: ~p"/raffles?#{filter_params}")

    # Assigning :my_var seems specific to the filter event, kept it as is
    socket = assign(socket, :my_var, "filter")

    {:noreply, socket}
  end
  @impl true
  def handle_info({TaskManager3Web.RaffleLive.FormComponent, {:saved, raffle}}, socket) do
    {:noreply, stream_insert(socket, :raffles, raffle)}
  end
  def handle_info(:load_posts, socket) do
    # Just to emulate the long-time request (optional, remove for real use)
    :timer.sleep(2000)

    # Retrieve the filter parameters stored in the socket
    filter_params = socket.assigns.current_filter_params

    # Fetch the posts using your context function and the retrieved params
    # posts = Raffles.filter_raffles(filter_params)

    # Update the socket with the fetched posts and set loading to false
    socket =
      socket
      |> stream(:raffles, Raffles.filter_raffles(filter_params), reset: true)
      # |> assign(:posts, posts)
      |> assign(:loading, false)

    # Optional: If you don't need current_filter_params after loading,
    # you could clear it, but it's often useful to keep for display purposes.
    # |> clear_assign(:current_filter_params)

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
      @status == :closed && "text-gray-600 border-gray-600"
    ]}>
      {@status}
    </div>
    """
  end
end
