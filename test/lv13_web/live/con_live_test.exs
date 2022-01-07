defmodule SupacWeb.ConLiveTest do
  use SupacWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Supac.SupFixtures

  alias Supac.Sup.Con
  alias Supac.Sup
  alias Supac.His

  setup :register_and_log_in_confirmed_user

  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    position: Enum.random(Ecto.Enum.values(Con, :position))
  }

  @update_attrs %{
    email: "some@updated.email",
    name: "some updated name",
    position: Enum.random(Ecto.Enum.values(Con, :position))
  }
  @invalid_attrs %{
    email: nil,
    name: nil,
    position: Enum.random(Ecto.Enum.values(Con, :position))
  }

  defp create_con(_) do
    con = con_fixture()
    %{con: con}
  end

  defp create_com(_) do
    com = com_fixture()
    %{com: com}
  end

  defp create_many_cons(_) do
    Enum.each(1..20, fn _ ->
      create_con(%{
        name: Faker.Pokemon.name,
        email: Faker.Internet.email,
        position: Enum.random(Ecto.Enum.values(Con, :position))
      })
    end)
  end

  describe "Index" do
    setup [:create_con, :create_com]

    test "lists all cons", %{conn: conn, con: con} do
      {:ok, _index_live, html} = live(conn, Routes.con_index_path(conn, :index))

      assert html =~ "New Con"
      assert html =~ con.email
    end

    test "saves new con", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live
            |> element("a", "New Con")
            |> render_click() =~ "New Con"

      assert_patch(index_live, Routes.con_index_path(conn, :new))

      assert index_live
             |> form("#con-form", con: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#con-form", con: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.con_index_path(conn, :index))

      assert html =~ "Con created successfully"
      assert html =~ "some@email.com"
    end

    test "updates con in listing", %{conn: conn, con: con} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live
            |> element("#con-#{con.id} a", "Edit")
            |> render_click() =~ "Edit Con"

      assert_patch(index_live, Routes.con_index_path(conn, :edit, con))

      assert index_live
             |> form("#con-form", con: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#con-form", con: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.con_index_path(conn, :index))

      # get updated con and update
      updated_con = Sup.recent_updated_con()
      update = His.get_latest_update()

      assert update.update["old"]["name"] == con.name
      assert update.update["new"]["name"] == updated_con.name

      assert html =~ "Con updated successfully"
      assert html =~ "some@updated.email"
    end

    test "add com to con", %{conn: conn, con: con, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live
            |> element("#con-#{con.id} a", "Edit")
            |> render_click() =~ "Edit Con"

      assert_patch(index_live, Routes.con_index_path(conn, :edit, con))

      assert index_live
            |> element("a", "Add Company")
            |> render_click()
      assert_redirected(index_live, "/coms?con_id=#{con.id}")

      # visit com with con id. ideally get redirected to here after clicking anchor tag with "Add Company"
      {:ok, com_view, _html} = live(conn, "/coms?con_id=#{con.id}")

      com_view
      |> element(~s{[href="/coms/#{com.id}/edit"]})
      |> render_click() =~ "Add Company to Contact"

      {:ok, con_view, _html} =
        com_view
        |> element("a", "Add Company to Contact")
        |> render_click()
        |> follow_redirect(conn, Routes.con_index_path(conn, :edit, con))

      # get updated appo and update
      updated_con = Sup.recent_updated_con()
      update = His.get_latest_update()

      # Make sure updated appo has com's id
      assert update.update["old"]["com_id"] == nil
      assert updated_con.com_id == update.update["new"]["com_id"]
      assert updated_con.com_id == com.id

      refute has_element?(con_view, "a", "Add Company")
    end

    test "deletes con in listing", %{conn: conn, con: con} do
      {:ok, index_live, _html} = live(conn, Routes.con_index_path(conn, :index))

      assert index_live |> element("#con-#{con.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#con-#{con.id}")
    end
  end

  describe "search cons" do
    setup [:create_many_cons]

    test "searching random con for 20 times", %{conn: conn} do
      cons = Sup.list_cons()
      assert Enum.count(cons) == 20

      {:ok, list_con, _html} = live(conn, Routes.con_index_path(conn, :index))

      Enum.each(1..20, fn _->
        con = Enum.random(cons)
        searched_list = list_con
          |> form("#con-search", con_search: %{term: con.name})
          |> render_submit()

        assert searched_list =~ inspect(con.id)
        assert searched_list =~ String.replace(con.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ con.email
        assert searched_list =~ Atom.to_string(con.position)
      end)
    end
  end
end


## Add com to con
### 1. open edit modal for con
### 2. click 'Add com to con' link
### 3. redirected to com index page with con's id
### 4. click one com's edit link
### 5. com's edit modal appears and the modal has 'Add com to con' link so click it
### 6. update the com with con's id and redirected to con edit modal
### 7. make sure that there is no 'Add com to con' link anymore and there is com's name
