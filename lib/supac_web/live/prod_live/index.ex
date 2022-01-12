defmodule SupacWeb.ProdLive.Index do
  use SupacWeb, :live_view

  alias Supac.Sup
  alias Supac.Sup.Prod

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket
      |> assign(:prods, list_prods())
      |> assign(:appo_id, nil)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Prod")
    |> assign(:prod, Sup.get_prod!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Prod")
    |> assign(:prod, %Prod{})
  end

  defp apply_action(socket, :index, %{"appo_id" => appo_id}) do
    socket
    |> assign(:page_title, "Listing Prods")
    |> assign(:appo_id, appo_id)
    |> assign(:prod, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Prods")
    |> assign(:prod, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prod = Sup.get_prod!(id)
    {:ok, _} = Sup.delete_prod(prod)

    {:noreply, assign(socket, :prods, list_prods())}
  end

  def handle_event("prod_search", %{"prod_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:prods, Sup.search_prods(term))}
  end

  defp list_prods do
    Sup.list_prods()
  end
end
