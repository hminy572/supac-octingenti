defmodule Lv13Web.UpdLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.HisFixtures

  @create_attrs %{update: "some update"}
  @update_attrs %{update: "some updated update"}
  @invalid_attrs %{update: nil}

  defp create_upd(_) do
    upd = upd_fixture()
    %{upd: upd}
  end

  describe "Index" do
    setup [:create_upd]

    test "lists all upds", %{conn: conn, upd: upd} do
      {:ok, _index_live, html} = live(conn, Routes.upd_index_path(conn, :index))

      assert html =~ "Listing Upds"
      assert html =~ upd.update
    end

    test "saves new upd", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.upd_index_path(conn, :index))

      assert index_live |> element("a", "New Upd") |> render_click() =~
               "New Upd"

      assert_patch(index_live, Routes.upd_index_path(conn, :new))

      assert index_live
             |> form("#upd-form", upd: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#upd-form", upd: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.upd_index_path(conn, :index))

      assert html =~ "Upd created successfully"
      assert html =~ "some update"
    end

    test "updates upd in listing", %{conn: conn, upd: upd} do
      {:ok, index_live, _html} = live(conn, Routes.upd_index_path(conn, :index))

      assert index_live |> element("#upd-#{upd.id} a", "Edit") |> render_click() =~
               "Edit Upd"

      assert_patch(index_live, Routes.upd_index_path(conn, :edit, upd))

      assert index_live
             |> form("#upd-form", upd: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#upd-form", upd: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.upd_index_path(conn, :index))

      assert html =~ "Upd updated successfully"
      assert html =~ "some updated update"
    end

    test "deletes upd in listing", %{conn: conn, upd: upd} do
      {:ok, index_live, _html} = live(conn, Routes.upd_index_path(conn, :index))

      assert index_live |> element("#upd-#{upd.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#upd-#{upd.id}")
    end
  end

  describe "Show" do
    setup [:create_upd]

    test "displays upd", %{conn: conn, upd: upd} do
      {:ok, _show_live, html} = live(conn, Routes.upd_show_path(conn, :show, upd))

      assert html =~ "Show Upd"
      assert html =~ upd.update
    end

    test "updates upd within modal", %{conn: conn, upd: upd} do
      {:ok, show_live, _html} = live(conn, Routes.upd_show_path(conn, :show, upd))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Upd"

      assert_patch(show_live, Routes.upd_show_path(conn, :edit, upd))

      assert show_live
             |> form("#upd-form", upd: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#upd-form", upd: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.upd_show_path(conn, :show, upd))

      assert html =~ "Upd updated successfully"
      assert html =~ "some updated update"
    end
  end
end
