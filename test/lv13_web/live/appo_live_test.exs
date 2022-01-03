defmodule Lv13Web.AppoLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  @create_attrs %{amount: 42, date: %{day: 2, month: 1, year: 2022}, deleted_at: %{day: 2, hour: 5, minute: 56, month: 1, year: 2022}, description: "some description", is_client: true, name: "some name", person_in_charge: "some person_in_charge", probability: 42, state: "some state"}
  @update_attrs %{amount: 43, date: %{day: 3, month: 1, year: 2022}, deleted_at: %{day: 3, hour: 5, minute: 56, month: 1, year: 2022}, description: "some updated description", is_client: false, name: "some updated name", person_in_charge: "some updated person_in_charge", probability: 43, state: "some updated state"}
  @invalid_attrs %{amount: nil, date: %{day: 30, month: 2, year: 2022}, deleted_at: %{day: 30, hour: 5, minute: 56, month: 2, year: 2022}, description: nil, is_client: false, name: nil, person_in_charge: nil, probability: nil, state: nil}

  defp create_appo(_) do
    appo = appo_fixture()
    %{appo: appo}
  end

  describe "Index" do
    setup [:create_appo]

    test "lists all appos", %{conn: conn, appo: appo} do
      {:ok, _index_live, html} = live(conn, Routes.appo_index_path(conn, :index))

      assert html =~ "Listing Appos"
      assert html =~ appo.description
    end

    test "saves new appo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live |> element("a", "New Appo") |> render_click() =~
               "New Appo"

      assert_patch(index_live, Routes.appo_index_path(conn, :new))

      assert index_live
             |> form("#appo-form", appo: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#appo-form", appo: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :index))

      assert html =~ "Appo created successfully"
      assert html =~ "some description"
    end

    test "updates appo in listing", %{conn: conn, appo: appo} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live |> element("#appo-#{appo.id} a", "Edit") |> render_click() =~
               "Edit Appo"

      assert_patch(index_live, Routes.appo_index_path(conn, :edit, appo))

      assert index_live
             |> form("#appo-form", appo: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#appo-form", appo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :index))

      assert html =~ "Appo updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes appo in listing", %{conn: conn, appo: appo} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live |> element("#appo-#{appo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#appo-#{appo.id}")
    end
  end

  describe "Show" do
    setup [:create_appo]

    test "displays appo", %{conn: conn, appo: appo} do
      {:ok, _show_live, html} = live(conn, Routes.appo_show_path(conn, :show, appo))

      assert html =~ "Show Appo"
      assert html =~ appo.description
    end

    test "updates appo within modal", %{conn: conn, appo: appo} do
      {:ok, show_live, _html} = live(conn, Routes.appo_show_path(conn, :show, appo))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Appo"

      assert_patch(show_live, Routes.appo_show_path(conn, :edit, appo))

      assert show_live
             |> form("#appo-form", appo: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#appo-form", appo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.appo_show_path(conn, :show, appo))

      assert html =~ "Appo updated successfully"
      assert html =~ "some updated description"
    end
  end
end
