defmodule SupacWeb.ConLive.FormComponent do
  use SupacWeb, :live_component

  alias Supac.Sup

  @impl true
  def update(%{con: con} = assigns, socket) do
    changeset = Sup.change_con(con)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("add_company", _, socket) do
    {:noreply, redirect(
      socket
      |> put_flash(
        :info,
        "Choose a company and click its edit button,
        then you can find 'add Company to Contact' link on the bottom of 'edit com' modal"),
      to: "/coms?con_id=#{socket.assigns.con.id}")
    }
  end

  def handle_event("validate", %{"con" => con_params}, socket) do
    changeset =
      socket.assigns.con
      |> Sup.change_con(con_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"con" => con_params}, socket) do
    save_con(socket, socket.assigns.action, con_params)
  end

  defp save_con(socket, :edit, con_params) do
    case Sup.update_con(socket.assigns.con, con_params) do
      {:ok, con} ->
        case create_an_update(
            socket.assigns.con, # old one
            con, # new one
            socket.assigns.current_user) do

          {:ok, _} ->
            {:noreply,
              socket
              |> put_flash(:info, "連絡先の編集内容が保存されました")
              |> push_redirect(to: socket.assigns.return_to)
            }

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign(socket, :changeset, changeset)}
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_con(socket, :new, con_params) do
    case Sup.create_con(con_params) do
      {:ok, _con} ->
        {:noreply,
         socket
         |> put_flash(:info, "新規連絡先が作成されました")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
