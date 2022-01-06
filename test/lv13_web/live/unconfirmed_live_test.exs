defmodule Lv13Web.UnconfirmedLiveTest do
  use Lv13Web.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup :register_and_log_in_user

  describe "create lead update" do

    test "simply visit /unconfimred", %{conn: conn, user: user} do
      msg = "Your email hasn't been confirmed yet. Make sure to click the confirmation link in the email sent to #{user.email}"

      {:ok, _view, html} = live(conn, Routes.live_path(conn, Lv13Web.UnconfirmedLive))

      assert html =~ String.replace(msg, "'", "&#39;")
    end

    test "visit /leads with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.lead_index_path(conn, :index))
      assert to == "/unconfirmed"
    end

    test "visit /coms with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.com_index_path(conn, :index))
      assert to == "/unconfirmed"
    end

    test "visit /cons with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.con_index_path(conn, :index))
      assert to == "/unconfirmed"
    end

    test "visit /appos with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.appo_index_path(conn, :index))
      assert to == "/unconfirmed"
    end

    test "visit /tasks with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.task_index_path(conn, :index))
      assert to == "/unconfirmed"
    end

    test "visit /prods with unconfirmed user and get redirected to /unconfirmed", %{conn: conn} do
      {:error, {:redirect, %{flash: _flash, to: to}}} = live(conn, Routes.prod_index_path(conn, :index))
      assert to == "/unconfirmed"
    end
  end
end
