defmodule Lv13Web.ComLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  @create_attrs %{deleted_at: %{day: 2, hour: 5, minute: 22, month: 1, year: 2022}, email: "some email", name: "some name", size: "some size", url: "some url"}
  @update_attrs %{deleted_at: %{day: 3, hour: 5, minute: 22, month: 1, year: 2022}, email: "some updated email", name: "some updated name", size: "some updated size", url: "some updated url"}
  @invalid_attrs %{deleted_at: %{day: 30, hour: 5, minute: 22, month: 2, year: 2022}, email: nil, name: nil, size: nil, url: nil}

  defp create_com(_) do
    com = com_fixture()
    %{com: com}
  end

  describe "Index" do
    setup [:create_com]

    test "lists all coms", %{conn: conn, com: com} do
      {:ok, _index_live, html} = live(conn, Routes.com_index_path(conn, :index))

      assert html =~ "Listing Coms"
      assert html =~ com.email
    end

    test "saves new com", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      assert index_live |> element("a", "New Com") |> render_click() =~
               "New Com"

      assert_patch(index_live, Routes.com_index_path(conn, :new))

      assert index_live
             |> form("#com-form", com: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#com-form", com: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.com_index_path(conn, :index))

      assert html =~ "Com created successfully"
      assert html =~ "some email"
    end

    test "updates com in listing", %{conn: conn, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      assert index_live |> element("#com-#{com.id} a", "Edit") |> render_click() =~
               "Edit Com"

      assert_patch(index_live, Routes.com_index_path(conn, :edit, com))

      assert index_live
             |> form("#com-form", com: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#com-form", com: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.com_index_path(conn, :index))

      assert html =~ "Com updated successfully"
      assert html =~ "some updated email"
    end

    test "deletes com in listing", %{conn: conn, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      assert index_live |> element("#com-#{com.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#com-#{com.id}")
    end
  end

  describe "Show" do
    setup [:create_com]

    test "displays com", %{conn: conn, com: com} do
      {:ok, _show_live, html} = live(conn, Routes.com_show_path(conn, :show, com))

      assert html =~ "Show Com"
      assert html =~ com.email
    end

    test "updates com within modal", %{conn: conn, com: com} do
      {:ok, show_live, _html} = live(conn, Routes.com_show_path(conn, :show, com))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Com"

      assert_patch(show_live, Routes.com_show_path(conn, :edit, com))

      assert show_live
             |> form("#com-form", com: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#com-form", com: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.com_show_path(conn, :show, com))

      assert html =~ "Com updated successfully"
      assert html =~ "some updated email"
    end
  end
end
