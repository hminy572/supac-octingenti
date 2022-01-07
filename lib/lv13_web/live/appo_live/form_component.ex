defmodule SupacWeb.AppoLive.FormComponent do
  use SupacWeb, :live_component

  alias Supac.Sup

  @impl true
  def update(%{appo: appo} = assigns, socket) do
    changeset = Sup.change_appo(appo)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add_prod", _unsigned_params, socket) do
    {:noreply, redirect(
      socket
      |> put_flash(
        :info,
        "Choose a prod and click its edit button,
        then you can find 'add Prod to Appointmnet' link on the bottom of 'edit prod' modal"),
      to: "/prods?appo_id=#{socket.assigns.appo.id}")
    }
  end

  def handle_event("add_company", _unsigned_params, socket) do
    {:noreply, redirect(
      socket
      |> put_flash(
        :info,
        "Choose a company and click its edit button,
        then you can find 'add Company to Appointmnet' link on the bottom of 'edit com' modal"),
      to: "/coms?appo_id=#{socket.assigns.appo.id}")
    }
  end

  def handle_event("validate", %{"appo" => appo_params}, socket) do
    changeset =
      socket.assigns.appo
      |> Sup.change_appo(appo_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"appo" => appo_params}, socket) do
    save_appo(socket, socket.assigns.action, appo_params)
  end

  defp save_appo(socket, :edit, appo_params) do
    case Sup.update_appo(socket.assigns.appo, appo_params) do
      {:ok, appo} ->
        case create_an_update(
            socket.assigns.appo, # old one
            appo, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Appointment updated successfully")
              |> push_redirect(to: socket.assigns.return_to)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_appo(socket, :new, appo_params) do
    case Sup.create_appo(appo_params) do
      {:ok, _appo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Appo created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
