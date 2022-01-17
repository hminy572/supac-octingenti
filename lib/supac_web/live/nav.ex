defmodule SupacWeb.Nav do
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    {:cont,
      socket
      |> attach_hook(:active_tab, :handle_params, &set_active_tab/3)
    }
  end

  defp set_active_tab(_params, _url, socket) do
    active_tab =
      case {socket.view, socket.assigns.live_action} do
        {SupacWeb.ChartLive, _} -> :chart
        {SupacWeb.AppoLive.Index, _} -> :appo
        {SupacWeb.ComLive.Index, _} -> :com
        {SupacWeb.ConLive.Index, _} -> :con
        {SupacWeb.LeadLive.Index, _} -> :lead
        {SupacWeb.ProdLive.Index, _} -> :prod
        {SupacWeb.TaskLive.Index, _} -> :task
        {_, _} -> nil
      end

      {:cont, assign(socket, active_tab: active_tab)}
  end

  def tab_style(active_tab, tab_name) do
    if active_tab == tab_name do
      "mx-1 mb-7 p-1 border-b-4 whitespace-nowrap border-b-amber-400 bg-amber-200"
    else
      "mx-1 mb-7 p-1 border-b-4 whitespace-nowrap hover:border-b-amber-400"
    end
  end
end
