defmodule Lv13Web.ProdLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  @create_attrs %{deleted_at: %{day: 2, hour: 5, minute: 32, month: 1, year: 2022}, name: "some name", price: 42}
  @update_attrs %{deleted_at: %{day: 3, hour: 5, minute: 32, month: 1, year: 2022}, name: "some updated name", price: 43}
  @invalid_attrs %{deleted_at: %{day: 30, hour: 5, minute: 32, month: 2, year: 2022}, name: nil, price: nil}

  defp create_prod(_) do
    prod = prod_fixture()
    %{prod: prod}
  end

  describe "Index" do
    setup [:create_prod]

    test "lists all prods", %{conn: conn, prod: prod} do
      {:ok, _index_live, html} = live(conn, Routes.prod_index_path(conn, :index))

      assert html =~ "Listing Prods"
      assert html =~ prod.name
    end

    test "saves new prod", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live |> element("a", "New Prod") |> render_click() =~
               "New Prod"

      assert_patch(index_live, Routes.prod_index_path(conn, :new))

      assert index_live
             |> form("#prod-form", prod: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#prod-form", prod: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prod_index_path(conn, :index))

      assert html =~ "Prod created successfully"
      assert html =~ "some name"
    end

    test "updates prod in listing", %{conn: conn, prod: prod} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live |> element("#prod-#{prod.id} a", "Edit") |> render_click() =~
               "Edit Prod"

      assert_patch(index_live, Routes.prod_index_path(conn, :edit, prod))

      assert index_live
             |> form("#prod-form", prod: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#prod-form", prod: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prod_index_path(conn, :index))

      assert html =~ "Prod updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes prod in listing", %{conn: conn, prod: prod} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live |> element("#prod-#{prod.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prod-#{prod.id}")
    end
  end

  describe "Show" do
    setup [:create_prod]

    test "displays prod", %{conn: conn, prod: prod} do
      {:ok, _show_live, html} = live(conn, Routes.prod_show_path(conn, :show, prod))

      assert html =~ "Show Prod"
      assert html =~ prod.name
    end

    test "updates prod within modal", %{conn: conn, prod: prod} do
      {:ok, show_live, _html} = live(conn, Routes.prod_show_path(conn, :show, prod))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Prod"

      assert_patch(show_live, Routes.prod_show_path(conn, :edit, prod))

      assert show_live
             |> form("#prod-form", prod: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#prod-form", prod: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prod_show_path(conn, :show, prod))

      assert html =~ "Prod updated successfully"
      assert html =~ "some updated name"
    end
  end
end
