defmodule Lv13Web.AppoLive.Index do
  use Lv13Web, :live_view

  alias Lv13.Sup
  alias Lv13.Sup.Appo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :appos, list_appos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Appo")
    |> assign(:appo, Sup.get_appo!(id))
  end

  defp apply_action(socket, :new, %{"com_id" => id}) do
    socket
    |> assign(:page_title, "Add Appo")
    |> assign(:appo, %Appo{com_id: id})
  end

  defp apply_action(socket, :new, %{"prod_id" => id}) do
    socket
    |> assign(:page_title, "Add Appo")
    |> assign(:appo, %Appo{prod_id: id})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Appo")
    |> assign(:appo, %Appo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Appos")
    |> assign(:appo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    appo = Sup.get_appo!(id)
    {:ok, _} = Sup.delete_appo(appo)

    {:noreply, assign(socket, :appos, list_appos())}
  end

  def handle_event("appo_search", %{"appo_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:appos, Sup.search_appos(term))}
  end

  defp list_appos do
    Sup.list_appos()
  end
end
