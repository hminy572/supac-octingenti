defmodule Lv13Web.ConLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  @create_attrs %{deleted_at: %{day: 2, hour: 5, minute: 39, month: 1, year: 2022}, email: "some email", name: "some name", position: "some position"}
  @update_attrs %{deleted_at: %{day: 3, hour: 5, minute: 39, month: 1, year: 2022}, email: "some updated email", name: "some updated name", position: "some updated position"}
  @invalid_attrs %{deleted_at: %{day: 30, hour: 5, minute: 39, month: 2, year: 2022}, email: nil, name: nil, position: nil}

  defp create_con(_) do
    con = con_fixture()
    %{con: con}
  end

  describe "Index" do
    setup [:create_con]

    test "lists all cons", %{conn: conn, con: con} do
      {:ok, _index_live, html} = live(conn, Routes.con_index_path(conn, :index))

      assert html =~ "Listing Cons"
      assert html =~ con.email
    end

    test "saves new con", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live |> element("a", "New Con") |> render_click() =~
               "New Con"

      assert_patch(index_live, Routes.con_index_path(conn, :new))

      assert index_live
             |> form("#con-form", con: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#con-form", con: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.con_index_path(conn, :index))

      assert html =~ "Con created successfully"
      assert html =~ "some email"
    end

    test "updates con in listing", %{conn: conn, con: con} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live |> element("#con-#{con.id} a", "Edit") |> render_click() =~
               "Edit Con"

      assert_patch(index_live, Routes.con_index_path(conn, :edit, con))

      assert index_live
             |> form("#con-form", con: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#con-form", con: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.con_index_path(conn, :index))

      assert html =~ "Con updated successfully"
      assert html =~ "some updated email"
    end

    test "deletes con in listing", %{conn: conn, con: con} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live |> element("#con-#{con.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#con-#{con.id}")
    end
  end

  describe "Show" do
    setup [:create_con]

    test "displays con", %{conn: conn, con: con} do
      {:ok, _show_live, html} = live(conn, Routes.con_show_path(conn, :show, con))

      assert html =~ "Show Con"
      assert html =~ con.email
    end

    test "updates con within modal", %{conn: conn, con: con} do
      {:ok, show_live, _html} = live(conn, Routes.con_show_path(conn, :show, con))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Con"

      assert_patch(show_live, Routes.con_show_path(conn, :edit, con))

      assert show_live
             |> form("#con-form", con: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#con-form", con: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.con_show_path(conn, :show, con))

      assert html =~ "Con updated successfully"
      assert html =~ "some updated email"
    end
  end
end
