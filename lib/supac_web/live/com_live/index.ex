defmodule SupacWeb.ComLive.Index do
  use SupacWeb, :live_view

  alias Supac.Sup
  alias Supac.Sup.Com

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(:coms, list_coms())
      |> assign(:con_id, nil)
      |> assign(:appo_id, nil)
      |> assign(:task_id, nil)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Com")
    |> assign(:com, Sup.get_com!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Com")
    |> assign(:com, %Com{})
  end

  defp apply_action(socket, :index, %{"con_id" => con_id}) do
    socket
    |> assign(:page_title, "Listing Coms")
    |> assign(:con_id, con_id)
    |> assign(:com, nil)
  end

  defp apply_action(socket, :index, %{"appo_id" => appo_id}) do
    socket
    |> assign(:page_title, "Listing Coms")
    |> assign(:appo_id, appo_id)
    |> assign(:com, nil)
  end

  defp apply_action(socket, :index, %{"task_id" => task_id}) do
    socket
    |> assign(:page_title, "Listing Coms")
    |> assign(:task_id, task_id)
    |> assign(:com, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Coms")
    |> assign(:com, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    com = Sup.get_com!(id)
    {:ok, _} = Sup.delete_com(com)

    {:noreply, assign(socket, :coms, list_coms())}
  end

  def handle_event("com_search", %{"com_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:coms, Sup.search_coms(term))}
  end

  defp list_coms do
    Sup.list_coms()
  end
end
