defmodule Lv13Web.UnconfirmedLive do
  use Lv13Web, :live_view

  alias Lv13.Accounts

  @impl true
  def mount(_, %{"user_token" => user_token} = _session, socket) do
    socket = socket
      |> assign_new( :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
        end)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p>
      Your email hasn't been confirmed yet. Make sure to click the confirmation link in the email sent to <%= @current_user.email %>
    </p>
    """
  end
end
