defmodule Lv13Web.Nav do
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
        {Lv13Web.ChartLive, _} -> :chart
        {Lv13Web.AppoLive.Index, _} -> :appo
        {Lv13Web.ComLive.Index, _} -> :com
        {Lv13Web.ConLive.Index, _} -> :con
        {Lv13Web.LeadLive.Index, _} -> :lead
        {Lv13Web.ProdLive.Index, _} -> :prod
        {Lv13Web.TaskLive.Index, _} -> :task
        {_, _} -> nil
      end

      {:cont, assign(socket, active_tab: active_tab)}
  end

  def tab_style(active_tab, tab_name) do
    if active_tab == tab_name do
      "mx-1 mb-7 p-1 border-b-4 border-b-amber-400 bg-amber-200"
    else
      "mx-1 mb-7 p-1 border-b-4 hover:border-b-amber-400"
    end
  end
end
