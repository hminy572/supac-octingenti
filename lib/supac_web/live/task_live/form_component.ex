defmodule SupacWeb.TaskLive.FormComponent do
  use SupacWeb, :live_component

  alias Supac.Sup

  @impl true
  def update(%{task: task} = assigns, socket) do
    changeset = Sup.change_task(task)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add_company", _unsigned_params, socket) do
    {:noreply,
      redirect(
        socket |> put_flash(
          :info,
          "Choose a company and click its edit button,
          then you can find 'add Company to Task' link on the bottom of 'edit com' modal"),
        to: "/coms?task_id=#{socket.assigns.task.id}")
    }
  end

  def handle_event("validate", %{"task" => task_params}, socket) do
    changeset =
      socket.assigns.task
      |> Sup.change_task(task_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"task" => task_params}, socket) do
    save_task(socket, socket.assigns.action, task_params)
  end

  defp save_task(socket, :edit, task_params) do
    case Sup.update_task(socket.assigns.task, task_params) do
      {:ok, task} ->
        case create_an_update(
            socket.assigns.task, # old one
            task, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "タスクの編集内容が保存されました")
              |> push_redirect(to: socket.assigns.return_to)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_task(socket, :new, task_params) do
    case Sup.create_task(task_params) do
      {:ok, _task} ->
        {:noreply,
         socket
         |> put_flash(:info, "新規タスクが作成されました")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
