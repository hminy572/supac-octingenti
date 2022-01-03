defmodule Lv13Web.ProdLive.FormComponent do
  use Lv13Web, :live_component

  alias Lv13.Sup
  require Logger

  @impl true
  def update(%{prod: prod} = assigns, socket) do
    changeset = Sup.change_prod(prod)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add_prod_to_appo", _, socket) do
    appo = Sup.get_appo!(socket.assigns.appo_id)
    Logger.info(inspect(appo))
    case Sup.update_appo(appo, %{prod_id: socket.assigns.prod.id}) do
      {:ok, updated_appo} ->
        case create_an_update(
            appo, # old one
            updated_appo, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Prod with id #{socket.assigns.prod.id} is associated with this appointment")
              |> push_redirect(to: "/appos/#{socket.assigns.appo_id}/edit")
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"prod" => prod_params}, socket) do
    changeset =
      socket.assigns.prod
      |> Sup.change_prod(prod_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"prod" => prod_params}, socket) do
    save_prod(socket, socket.assigns.action, prod_params)
  end

  defp save_prod(socket, :edit, prod_params) do
    case Sup.update_prod(socket.assigns.prod, prod_params) do
      {:ok, prod} ->
        case create_an_update(
            socket.assigns.prod, # old one
            prod, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Prod updated successfully")
              |> push_redirect(to: socket.assigns.return_to)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_prod(socket, :new, prod_params) do
    case Sup.create_prod(prod_params) do
      {:ok, _prod} ->
        {:noreply,
         socket
         |> put_flash(:info, "Prod created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
