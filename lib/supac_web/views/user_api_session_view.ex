defmodule SupacWeb.UserApiSessionView do
  use SupacWeb, :view

  def render("token.json", %{token: token}) do
    %{token: token}
  end

  def render("status.json", %{status: status}) do
    %{status: status}
  end
end
