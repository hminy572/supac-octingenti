defmodule SupacWeb.UserApiSessionController do
  use SupacWeb, :controller
  alias Supac.Accounts
  require Logger

  # method to authenticate json api with token
  def create(conn, %{"email" => email, "password" => password}) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      render(
        conn,
        "token.json",
        token: Accounts.generate_user_session_token(user) |> Base.encode64()
      )
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(SupacWeb.ErrorView)
      |> render(:"401")
    end
  end

  def status(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "status.json", status: user.email <> " enable")
  end
end
