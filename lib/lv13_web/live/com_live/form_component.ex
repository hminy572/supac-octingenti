defmodule Lv13Web.ComLive.FormComponent do
  use Lv13Web, :live_component

  alias Lv13.Sup

  require Logger
  @impl true
  def update(%{com: com} = assigns, socket) do
    changeset = Sup.change_com(com)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add_com_to_con", _, socket) do
    con = Sup.get_con!(socket.assigns.con_id)
    case Sup.update_con(con, %{com_id: socket.assigns.com.id}) do
      {:ok, updated_con} ->
        case create_an_update(
          con, # old one
          updated_con, # new one
          socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Company with id #{socket.assigns.com.id} is associated with this contact")
              |> push_redirect(to: Routes.con_index_path(socket, :edit, con)) # "/cons/#{socket.assigns.con_id}/edit"
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("add_com_to_appo", _, socket) do
    appo = Sup.get_appo!(socket.assigns.appo_id)
    case Sup.update_appo(appo, %{com_id: socket.assigns.com.id}) do
      {:ok, updated_appo} ->
        case create_an_update(
          appo, # old one
          updated_appo, # new one
          socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Company with id #{socket.assigns.com.id} is associated with this appointment")
              |> push_redirect(to: Routes.appo_index_path(socket, :edit, appo)) # "/appos/#{socket.assigns.appo_id}/edit"
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("add_com_to_task", _, socket) do
    task = Sup.get_task!(socket.assigns.task_id)
    case Sup.update_task(task, %{com_id: socket.assigns.com.id}) do
      {:ok, updated_task} ->
        case create_an_update(
          task, # old one
          updated_task, # new one
          socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Company with id #{socket.assigns.com.id} is associated with this contact")
              |> push_redirect(to: Routes.task_index_path(socket, :edit, task)) # "/tasks/#{socket.assigns.task_id}/edit"
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_event("validate", %{"com" => com_params}, socket) do
    changeset =
      socket.assigns.com
      |> Sup.change_com(com_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"com" => com_params}, socket) do
    save_com(socket, socket.assigns.action, com_params)
  end

  defp save_com(socket, :edit, com_params) do
    case Sup.update_com(socket.assigns.com, com_params) do
      {:ok, com} ->
        case create_an_update(
            socket.assigns.com, # old one
            com, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "Com updated successfully")
              |> push_redirect(to: socket.assigns.return_to)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_com(socket, :new, com_params) do
    case Sup.create_com(com_params) do
      {:ok, _com} ->
        {:noreply,
         socket
         |> put_flash(:info, "Com created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
