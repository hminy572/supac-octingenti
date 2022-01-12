defmodule SupacWeb.SearchLive do
  use SupacWeb, :live_view
  alias Supac.Sup

  @impl true
  def mount(%{"term" => term}, _, socket) do
    {:ok, assign(socket, %{
      term: term,
      results: Sup.search(term)
    })}
  end

  defp noresult(results) do
    if !Enum.any?(results.appos) &&
      !Enum.any?(results.coms) &&
      !Enum.any?(results.cons) &&
      !Enum.any?(results.leads) &&
      !Enum.any?(results.prods) &&
      !Enum.any?(results.tasks) do
      "no results found"
    else
      ""
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-2 sm:mx-8 md:mx-16 lg:mx-24 xl:mx-48">
      <%= noresult(@results) %>
      <div class="mt-8 mb-4">search_term: <%= @term %></div>

      <%= for result <- @results.appos do %>
        <%= live_redirect to: Routes.appo_index_path(@socket, :edit, result), id: "appo-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Appointment</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>

      <%= for result <- @results.coms do %>
        <%= live_redirect to: Routes.com_index_path(@socket, :edit, result), id: "com-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Company</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>

      <%= for result <- @results.cons do %>
        <%= live_redirect to: Routes.con_index_path(@socket, :edit, result), id: "con-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Contact</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>

      <%= for result <- @results.leads do %>
        <%= live_redirect to: Routes.lead_index_path(@socket, :edit, result), id: "lead-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Lead</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>

      <%= for result <- @results.prods do %>
        <%= live_redirect to: Routes.prod_index_path(@socket, :edit, result), id: "prod-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Prod</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>

      <%= for result <- @results.tasks do %>
        <%= live_redirect to: Routes.task_index_path(@socket, :edit, result), id: "task-#{result.id}" do %>
          <div class="my-2 px-4 py-2 bg-amber-100 hover:bg-amber-200 rounded-lg">
            <h3>Task</h3>
            <div class="">name: <%= result.name %></div>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end
end
