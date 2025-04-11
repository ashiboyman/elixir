defmodule TaskManager3Web.RaffleLive.FormComponent do
  use TaskManager3Web, :live_component

  alias TaskManager3.Raffles

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage raffle records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="raffle-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:prize]} type="text" label="Prize" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:ticket_price]} type="number" label="Ticket price" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(TaskManager3.Raffles.Raffle, :status)}
        />
        <.input field={@form[:image_path]} type="text" label="Image path" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Raffle</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{raffle: raffle} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Raffles.change_raffle(raffle))
     end)}
  end

  @impl true
  def handle_event("validate", %{"raffle" => raffle_params}, socket) do
    changeset = Raffles.change_raffle(socket.assigns.raffle, raffle_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"raffle" => raffle_params}, socket) do
    save_raffle(socket, socket.assigns.action, raffle_params)
  end

  defp save_raffle(socket, :edit, raffle_params) do
    case Raffles.update_raffle(socket.assigns.raffle, raffle_params) do
      {:ok, raffle} ->
        notify_parent({:saved, raffle})

        {:noreply,
         socket
         |> put_flash(:info, "Raffle updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_raffle(socket, :new, raffle_params) do
    case Raffles.create_raffle(raffle_params) do
      {:ok, raffle} ->
        notify_parent({:saved, raffle})

        {:noreply,
         socket
         |> put_flash(:info, "Raffle created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
