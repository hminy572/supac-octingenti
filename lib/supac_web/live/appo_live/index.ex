defmodule SupacWeb.AppoLive.Index do
  use SupacWeb, :live_view

  alias Supac.Sup
  alias Supac.Sup.Appo

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
    |> assign(:page_title, "アポを編集")
    |> assign(:appo, Sup.get_appo!(id))
  end

  defp apply_action(socket, :new, %{"com_id" => id}) do
    socket
    |> assign(:page_title, "アポを追加")
    |> assign(:appo, %Appo{com_id: id})
  end

  defp apply_action(socket, :new, %{"prod_id" => id}) do
    socket
    |> assign(:page_title, "アポを追加")
    |> assign(:appo, %Appo{prod_id: id})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "新規アポ")
    |> assign(:appo, %Appo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "アポ一覧")
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
