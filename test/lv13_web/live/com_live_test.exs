defmodule SupacWeb.ComLiveTest do
  use SupacWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Supac.SupFixtures

  alias Supac.Sup.Com
  alias Supac.Sup

  setup :register_and_log_in_confirmed_user

  @create_attrs %{
    email: "some@email.com",
    name: "some name",
    size: Enum.random(Ecto.Enum.values(Com, :size)),
    url: "http://some.url"
  }
  @update_attrs %{
    email: "some@updated.email",
    name: "some updated name",
    size: Enum.random(Ecto.Enum.values(Com, :size)),
    url: "http://some_updated.url"
  }
  @invalid_attrs %{
    email: nil,
    name: nil,
    size: Enum.random(Ecto.Enum.values(Com, :size)),
    url: nil
  }

  defp create_com(_) do
    com = com_fixture()
    %{com: com}
  end

  defp create_many_coms(_) do
    Enum.each(1..20, fn _ ->
      create_com(%{
        name: Faker.Pokemon.name,
        email: Faker.Internet.email,
        url: Faker.Internet.url,
        size: Enum.random(Ecto.Enum.values(Com, :size))
      })
    end)
  end

  describe "Index" do
    setup [:create_com]

    test "lists all coms", %{conn: conn, com: com} do
      {:ok, _index_live, html} = live(conn, Routes.com_index_path(conn, :index))

      assert html =~ "New Com"
      assert html =~ com.email
    end

    test "saves new com", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      assert index_live
            |> element("a", "New Com")
            |> render_click() =~ "New Com"

      assert_patch(index_live, Routes.com_index_path(conn, :new))

      assert index_live
             |> form("#com-form", com: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#com-form", com: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.com_index_path(conn, :index))

      assert html =~ "Com created successfully"
      assert html =~ "some@email.com"
    end

    test "updates com in listing", %{conn: conn, com: com} do
      # visit "/coms"
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      # open 'edit' modal for com with the com's id
      assert index_live |> element("#com-#{com.id} a", "Edit") |> render_click() =~ "Edit Com"

      # send form to update the com with invalid attrs and recieve validation error
      assert index_live
             |> form("#com-form", com: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      # send form to update the com with valid attrs and redirected to the same LiveView(as 'updated_live')
      {:ok, _updated_live, html} =
        index_live
        |> form("#com-form", com: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.com_index_path(conn, :index))

      assert html =~ "Com updated successfully"
      assert html =~ "some@updated.email"

    end

    test "add con", %{conn: conn, com: com} do
      # visit "/coms"
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      # open 'edit' modal for com with the com's id
      assert index_live |> element("#com-#{com.id} a", "Edit") |> render_click() =~ "Edit Com"
      assert has_element?(index_live, ~s{[href="/cons/new?com_id=#{com.id}"]})

      # click anchor tag to create a new con with the com and redirected to con LiveView
      {:ok, con_view, html} =
        index_live
        |> element(~s{[href="/cons/new?com_id=#{com.id}"]})
        |> render_click()
        |> follow_redirect(conn, Routes.con_index_path(conn, :new, %{"com_id" => com.id}))

      # assert the con you are about to create is tied with the com id
      assert html =~ "Add Con"
      assert has_element?(con_view, ~s{[id="con-form_com_id"][value="#{com.id}"]})
    end

    test "add appo", %{conn: conn, com: com} do
      # visit "/coms"
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      # open 'edit' modal for com with the com's id
      assert index_live |> element("#com-#{com.id} a", "Edit") |> render_click() =~ "Edit Com"
      assert has_element?(index_live, ~s{[href="/appos/new?com_id=#{com.id}"]})

      # click anchor tag to create a new appo with the com and redirected to appo LiveView
      {:ok, appo_view, html} =
        index_live
        |> element(~s{[href="/appos/new?com_id=#{com.id}"]})
        |> render_click()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :new, %{"com_id" => com.id}))

      # assert the appo you are about to create is tied with the com id
      assert html =~ "Add Appo"
      assert has_element?(appo_view, ~s{[id="appo-form_com_id"][value="#{com.id}"]})
    end

    test "add task", %{conn: conn, com: com} do
      # visit "/coms"
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      # open 'edit' modal for com with the com's id
      assert index_live |> element("#com-#{com.id} a", "Edit") |> render_click() =~ "Edit Com"
      assert has_element?(index_live, ~s{[href="/tasks/new?com_id=#{com.id}"]})

      # click anchor tag to create a new task with the com and redirected to task LiveView
      {:ok, task_view, html} =
        index_live
        |> element(~s{[href="/tasks/new?com_id=#{com.id}"]})
        |> render_click()
        |> follow_redirect(conn, Routes.task_index_path(conn, :new, %{"com_id" => com.id}))

      # assert the task you are about to create is tied with the com id
      assert html =~ "Add Task"
      assert has_element?(task_view, ~s{[id="task-form_com_id"][value="#{com.id}"]})
    end

    test "deletes com in listing", %{conn: conn, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.com_index_path(conn, :index))

      assert index_live |> element("#com-#{com.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#com-#{com.id}")
    end
  end

  describe "search coms" do
    setup [:create_many_coms]

    test "searching random com for 20 times", %{conn: conn} do
      coms = Sup.list_coms()
      assert Enum.count(coms) == 20

      {:ok, list_com, _html} = live(conn, Routes.com_index_path(conn, :index))

      Enum.each(1..20, fn _->
        com = Enum.random(coms)
        searched_list = list_com
          |> form("#com-search", com_search: %{term: com.name})
          |> render_submit()

        assert searched_list =~ inspect(com.id)
        assert searched_list =~ String.replace(com.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ com.url
        assert searched_list =~ Atom.to_string(com.size)
      end)
    end
  end
end


## add com to con
### 1. open edit modal for com
### 2. click link to related con
### 3. redirected to the con
### 4. create new con
### 5. reopen the newly created con and make sure it has com id
### 6. click the com link to go back to the initial com edit modal

## add com to appo
### 1. open edit modal for com
### 2. click link to related appo
### 3. redirected to the appo
### 4. create new appo
### 5. reopen the newly created appo and make sure it has com id
### 6. click the com link to go back to the initial com edit modal

## add com to task
### 1. open edit modal for com
### 2. click link to related task
### 3. redirected to the task
### 4. create new task
### 5. reopen the newly created task and make sure it has com id
### 6. click the com link to go back to the initial com edit modal
