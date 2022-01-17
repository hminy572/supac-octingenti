defmodule SupacWeb.AppoLiveTest do
  @moduledoc """
  Tests for Sup.Appo
  """

  use SupacWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Supac.SupFixtures
  alias Supac.Sup
  alias Supac.His
  alias Supac.Sup.Appo

  setup :register_and_log_in_confirmed_user

  @create_attrs %{
    amount: 42,
    date: Faker.Date.backward(10),
    description: "some description",
    is_client: true,
    name: "some name",
    person_in_charge: "user1",
    probability: 120.5,
    state: Enum.random(Ecto.Enum.values(Appo, :state))
  }
  @update_attrs %{
    amount: 43,
    date: Faker.Date.backward(10),
    description: "some updated description",
    is_client: false,
    name: "some updated name",
    person_in_charge: "user1",
    probability: 456.7,
    state: Enum.random(Ecto.Enum.values(Appo, :state))
  }
  @invalid_attrs %{
    amount: nil,
    date: Faker.Date.backward(10),
    description: nil,
    is_client: false,
    name: nil,
    person_in_charge: "user1",
    probability: nil,
    state: Enum.random(Ecto.Enum.values(Appo, :state))
  }

  defp create_appo(_) do
    appo = appo_fixture()
    %{appo: appo}
  end

  defp create_com(_) do
    com = com_fixture()
    %{com: com}
  end

  defp create_prod(_) do
    prod = prod_fixture()
    %{prod: prod}
  end

  describe "Index" do
    setup [:create_appo, :create_com, :create_prod]

    test "lists all appos", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.appo_index_path(conn, :index))

      assert html =~ "新規アポ"
    end

    test "saves new appo", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live
            |> element("a", "新規アポ")
            |> render_click() =~ "新規アポ"

      assert_patch(index_live, Routes.appo_index_path(conn, :new))

      assert index_live
             |> form("#appo-form", appo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#appo-form", appo: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :index))

      assert html =~ "Appo created successfully"
    end

    test "updates appo in listing", %{conn: conn, appo: appo} do

      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live
            |> element("#appo-#{appo.id} a", "編集")
            |> render_click() =~ "アポを編集"

      assert_patch(index_live, Routes.appo_index_path(conn, :edit, appo))

      assert index_live
             |> form("#appo-form", appo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#appo-form", appo: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :index))

      # get updated appo and update
      updated_appo = Sup.recent_updated_appo()
      update = His.get_latest_update()

      assert update.update["old"]["name"] == appo.name
      assert update.update["new"]["name"] == updated_appo.name

      assert html =~ "Appointment updated successfully"
    end

    test "add com to appo", %{conn: conn, appo: appo, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live
            |> element("#appo-#{appo.id} a", "編集")
            |> render_click() =~ "アポを編集"

      assert_patch(index_live, Routes.appo_index_path(conn, :edit, appo))

      assert index_live
            |> element("a", "会社を追加")
            |> render_click()
      assert_redirected(index_live, "/coms?appo_id=#{appo.id}")

      # visit com with con id. ideally get redirected to here after clicking anchor tag with "Add Company"
      {:ok, com_view, _html} = live(conn, "/coms?appo_id=#{appo.id}")

      # open edit modal
      com_view
      |> element(~s{[href="/coms/#{com.id}/edit"]})
      |> render_click() =~ "Add Company to Appointment"

      # update com with appo id
      {:ok, appo_view, _html} =
        com_view
        |> element("a", "Add Company to Appointment")
        |> render_click()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :edit, appo))

      # get updated appo and update
      updated_appo = Sup.recent_updated_appo()
      update = His.get_latest_update()

      # Make sure updated appo has com's id
      assert update.update["old"]["com_id"] == nil
      assert updated_appo.com_id == update.update["new"]["com_id"]
      assert updated_appo.com_id == com.id

      refute has_element?(appo_view, "a", "Add Company")
    end

    test "add prod to appo", %{conn: conn, appo: appo, prod: prod} do
      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live
            |> element("#appo-#{appo.id} a", "編集")
            |> render_click() =~ "アポを編集"

      assert_patch(index_live, Routes.appo_index_path(conn, :edit, appo))

      assert index_live
            |> element("a", "商品を追加")
            |> render_click()
      assert_redirected(index_live, "/prods?appo_id=#{appo.id}")

      # visit prod with appo id. ideally get redirected to here after clicking anchor tag with "Add Prod"
      {:ok, prod_view, _html} = live(conn, "/prods?appo_id=#{appo.id}")

      # open edit modal
      prod_view
      |> element(~s{[href="/prods/#{prod.id}/edit"]})
      |> render_click() =~ "Add Prod to Appointment"

      # update prod with appo id
      {:ok, appo_view, _html} =
        prod_view
        |> element("a", "Add Prod to Appointment")
        |> render_click()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :edit, appo))

      # get updated appo and update
      updated_appo = Sup.recent_updated_appo()
      update = His.get_latest_update()

      # Make sure updated appo has prod's id
      assert update.update["old"]["prod_id"] == nil
      assert updated_appo.prod_id == update.update["new"]["prod_id"]
      assert updated_appo.prod_id == prod.id

      refute has_element?(appo_view, "a", "Add prod")
    end

    test "deletes appo in listing", %{conn: conn, appo: appo} do

      {:ok, index_live, _html} = live(conn, Routes.appo_index_path(conn, :index))

      assert index_live |> element("#appo-#{appo.id} a", "削除") |> render_click()
      refute has_element?(index_live, "#appo-#{appo.id}")
    end
  end

  describe "search appos" do
    test "searching random appo for 20 times", %{conn: conn} do
      Enum.each(1..20, fn _ ->
        Sup.create_appo(%{
          name: Faker.Pokemon.name,
          state: Enum.random(Ecto.Enum.values(Appo, :state)),
          amount: :rand.uniform(10) * 1000,
          probability: :rand.uniform(),
          description: Faker.Lorem.paragraph,
          is_client: false,
          person_in_charge: "user1",
          date: Faker.Date.backward(10)
        })
      end)

      appos = Sup.list_appos()
      assert Enum.count(appos) == 20

      {:ok, list_appo, _html} = live(conn, Routes.appo_index_path(conn, :index))

      Enum.each(1..20, fn _->
        appo = Enum.random(appos)
        searched_list = list_appo
          |> form("#appo-search", appo_search: %{term: appo.name})
          |> render_submit()

        assert searched_list =~ inspect(appo.id)
        assert searched_list =~ String.replace(appo.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ Atom.to_string(appo.state)
      end)
    end
  end
end


## Add com to appo
### 1. open edit modal for appo
### 2. click 'Add com to appo' link
### 3. redirected to com index page with appo's id
### 4. click one certain com's edit link
### 5. com's edit modal appears and the modal has 'Add com to appo' link so click it
### 6. update the com with appo's id and redirected to appo edit modal
### 7. make sure that there is com's name
