defmodule SupacWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias Supac.Accounts

  require Logger

  def on_mount(:default, params, %{"user_token" => user_token} = _session, socket) do
    Logger.info(params)
    socket = socket
      |> assign_new( :current_user, fn ->
        Accounts.get_user_by_session_token(user_token)
    end)

    if socket.assigns.current_user.confirmed_at do
      {:cont, socket }
    else
      {:halt, redirect(socket
        |> put_flash(:error, "あなたのEメールアドレス宛に確認用のメールが送信されています。そのメールのリンクをクリックしてください。"),
        to: "/unconfirmed")
      }
    end
  end

  # in case :default doesn't match
  def on_mount(_, _params, _session, socket) do
    Logger.info("did not match")
    {:cont, socket}
  end

end
