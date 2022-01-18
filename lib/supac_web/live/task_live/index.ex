defmodule SupacWeb.TaskLive.Index do
  use SupacWeb, :live_view

  alias Supac.Sup
  alias Supac.Sup.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :tasks, list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "タスクを編集")
    |> assign(:task, Sup.get_task!(id))
  end

  defp apply_action(socket, :new, %{"com_id" => id}) do
    socket
    |> assign(:page_title, "タスクを追加")
    |> assign(:task, %Task{com_id: id})
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "新規タスク")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "タスク一覧")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Sup.get_task!(id)
    {:ok, _} = Sup.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  def handle_event("task_search", %{"task_search" => %{"term" => term}}, socket) do
    {:noreply, socket |> assign(:tasks, Sup.search_tasks(term))}
  end

  defp list_tasks do
    Sup.list_tasks()
  end
end
