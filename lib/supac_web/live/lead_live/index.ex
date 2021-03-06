defmodule SupacWeb.LeadLive.Index do
  use SupacWeb, :live_view

  alias Supac.Sup
  alias Supac.Sup.Lead

  require Logger

  @impl true
  def mount(_params, session, socket) do
    Logger.info(inspect(session))
    {:ok, socket |> assign(:leads, list_leads())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "リードを編集")
    |> assign(:lead, Sup.get_lead!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "新規リード")
    |> assign(:lead, %Lead{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "リード一覧")
    |> assign(:lead, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    lead = Sup.get_lead!(id)
    {:ok, _} = Sup.delete_lead(lead)

    {:noreply, assign(socket, :leads, list_leads())}
  end

  def handle_event("lead_search", %{"lead_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:leads, Sup.search_leads(term))}
  end

  defp list_leads do
    Sup.list_leads()
  end
end
