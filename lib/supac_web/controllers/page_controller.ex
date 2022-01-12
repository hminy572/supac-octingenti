defmodule SupacWeb.PageController do
  use SupacWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
