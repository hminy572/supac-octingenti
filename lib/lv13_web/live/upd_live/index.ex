defmodule Lv13Web.UpdLive.Index do
  use Lv13Web, :live_view

  alias Lv13.His

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :updates, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Updates")
    |> assign(:update, nil)
  end

  @impl true
  def handle_event("search", params, socket) do
    {"update", %{"from" => from, "term" => term, "to" => to}} = Enum.at(params, 1)
    # params = [
    #   {"_csrf_token", "EnUyAg1xLDZjFGU_PEsfJHZVBgo9FTstx9fKIEVz1NWvEsXbO3wXwRjg"},
    #   {"udpate", %{"from" => "", "term" => "", "to" => ""}}
    # ]

    to_ndt =
      if to == "" do
        NaiveDateTime.utc_now()
      else
        # expected value for 'to' is "2015-01-23T23:50" <- need to add second part
        Regex.replace(~r/T/, to, " ") <> ":00" |> NaiveDateTime.from_iso8601!()
      end

    from_ndt =
      if from == "" do
        ~N[2000-01-01 00:00:00]
      else
        # expected value for 'to' is "2015-01-23T23:50" <- need to add second part
        Regex.replace(~r/T/, from, " ") <> ":00" |> NaiveDateTime.from_iso8601!()
      end

    {
      :noreply,
      socket
      |> assign(:updates, His.search_only_updated(from_ndt, to_ndt, term))
    }
  end
end
