defmodule Lv13Web.PageController do
  use Lv13Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
