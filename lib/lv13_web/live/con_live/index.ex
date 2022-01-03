defmodule Lv13Web.ConLive.Index do
  use Lv13Web, :live_view

  alias Lv13.Sup
  alias Lv13.Sup.Con

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(:cons, list_cons())
      |> assign(:selected_com, "hoge")
      |> assign(:cand_coms, [])
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Con")
    |> assign(:con, Sup.get_con!(id))
  end

  defp apply_action(socket, :new, %{"com_id" => id}) do
    socket
    |> assign(:page_title, "Add Con")
    |> assign(:con, %Con{com_id: id})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Con")
    |> assign(:con, %Con{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cons")
    |> assign(:con, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    con = Sup.get_con!(id)
    {:ok, _} = Sup.delete_con(con)

    {:noreply, assign(socket, :cons, list_cons())}
  end

  def handle_event("con_search", %{"con_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:cons, Sup.search_cons(term))}
  end

  defp list_cons do
    Sup.list_cons()
  end
end
