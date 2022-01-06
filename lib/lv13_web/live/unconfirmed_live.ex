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
    <div class="flex justify-center mt-16">
      <div class="mx-2 w-11/12 sm:w-10/12 md:w-9/12 lg:w-8/12 xl:w-7/12">
        <p class="text-xl">Your email hasn't been confirmed yet. Make sure to click the confirmation link in the email sent to <%= @current_user.email %></p>
      </div>
    </div>
    """
  end
end
