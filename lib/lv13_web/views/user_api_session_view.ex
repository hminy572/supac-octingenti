defmodule Lv13Web.UserApiSessionView do
  use Lv13Web, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end

  def render("status.json", %{status: status}) do
    %{status: status}
  end
end
