defmodule SupacWeb.PageLive do
  use SupacWeb, :live_view

  require Logger

  @impl true
  def mount(_, _, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("click", _, socket) do
    Logger.info("clicked")
    {:noreply, socket}
  end

  def handle_event("input", _, socket) do
    Logger.info(inspect(Time.utc_now()))
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div phx-click="click">Page</div>
    <input phx-click="input" type="text" phx-click-away="input">
    """
  end

end
