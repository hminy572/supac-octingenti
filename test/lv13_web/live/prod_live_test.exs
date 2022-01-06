defmodule Lv13Web.ProdLiveTest do
  use Lv13Web.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  alias Lv13.Sup

  setup :register_and_log_in_confirmed_user

  @create_attrs %{name: "some name", price: 42}
  @update_attrs %{name: "some updated name", price: 43}
  @invalid_attrs %{name: nil, price: nil}

  defp create_prod(_) do
    prod = prod_fixture()
    %{prod: prod}
  end

  defp create_many_prods(_) do
    Enum.each(1..20, fn _ ->
      create_prod(%{
        name: Faker.Pokemon.name,
        price: :rand.uniform(10) * 1000
      })
    end)
  end

  describe "Index" do
    setup [:create_prod]

    test "lists all prods", %{conn: conn, prod: prod} do
      {:ok, _index_live, html} = live(conn, Routes.prod_index_path(conn, :index))

      assert html =~ "New Prod"
      assert html =~ prod.name
    end

    test "saves new prod", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live |> element("a", "New Prod") |> render_click() =~
               "New Prod"

      assert_patch(index_live, Routes.prod_index_path(conn, :new))

      assert index_live
             |> form("#prod-form", prod: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

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
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#prod-form", prod: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.prod_index_path(conn, :index))

      assert html =~ "Prod updated successfully"
      assert html =~ "some updated name"
    end

    test "add appo", %{conn: conn, prod: prod} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live
            |> element("#prod-#{prod.id} a", "Edit")
            |> render_click() =~ "Edit Prod"
      assert has_element?(index_live, ~s{[href="/appos/new?prod_id=#{prod.id}"]})

      # click anchor tag to create new appo with the prod and redirected to appo LiveView
      {:ok, appo_view, html} =
        index_live
        |> element(~s{[href="/appos/new?prod_id=#{prod.id}"]})
        |> render_click()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :new, %{"prod_id" => prod.id}))

      # assert the appo you are about to create is tied with the prod id
      assert html =~ "Add Appo"
      assert has_element?(appo_view, ~s{[id="appo-form_prod_id"][value="#{prod.id}"]})
    end

    test "deletes prod in listing", %{conn: conn, prod: prod} do
      {:ok, index_live, _html} = live(conn, Routes.prod_index_path(conn, :index))

      assert index_live |> element("#prod-#{prod.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#prod-#{prod.id}")
    end
  end

  describe "search prods" do
    setup [:create_many_prods]

    test "searching random prod for 20 times", %{conn: conn} do
      prods = Sup.list_prods()
      assert Enum.count(prods) == 20

      {:ok, list_prod, _html} = live(conn, Routes.prod_index_path(conn, :index))

      Enum.each(1..20, fn _->
        prod = Enum.random(prods)
        searched_list = list_prod
          |> form("#prod-search", prod_search: %{term: prod.name})
          |> render_submit()

        assert searched_list =~ inspect(prod.id)
        assert searched_list =~ String.replace(prod.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ inspect(prod.price)
      end)
    end
  end
end


## add prod to appo
### 1. open edit modal for prod
### 2. click link to related appo
### 3. redirected to the appo
### 4. create new appo
### 5. reopen the newly created appo and make sure it has prod id
### 6. click the prod link to go back to the initial prod edit modal
