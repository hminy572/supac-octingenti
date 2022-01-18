defmodule SupacWeb.TaskLiveTest do
  use SupacWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Supac.SupFixtures

  alias Supac.Sup.Task
  alias Supac.Sup
  alias Supac.His

  setup :register_and_log_in_confirmed_user

  @create_attrs %{
    content: "some content",
    due_date: Date.utc_today(),
    name: "some name",
    person_in_charge: "user1",
    priority: Enum.random(Ecto.Enum.values(Task, :priority))
  }
  @update_attrs %{
    content: "some updated content",
    due_date: Date.utc_today(),
    name: "some updated name",
    person_in_charge: "user1",
    priority: Enum.random(Ecto.Enum.values(Task, :priority))
  }
  @invalid_attrs %{
    content: nil,
    due_date: Date.utc_today(),
    name: nil,
    person_in_charge: "user1",
    priority: Enum.random(Ecto.Enum.values(Task, :priority))
  }

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end

  defp create_com(_) do
    com = com_fixture()
    %{com: com}
  end

  defp create_many_tasks(_) do
    Enum.each(1..20, fn _ ->
      create_task(%{
        name: Faker.Pokemon.name,
        due_date: Faker.Date.backward(10),
        person_in_charge: "user1",
        priority: Enum.random(Ecto.Enum.values(Task, :priority)),
        content: Faker.Lorem.paragraph
      })
    end)
  end

  describe "Index" do
    setup [:create_task, :create_com]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "新規タスク"
      assert html =~ task.name
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("a", "新規タスク") |> render_click() =~
               "新規タスク"

      assert_patch(index_live, Routes.task_index_path(conn, :new))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "新規タスクが作成されました"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "編集") |> render_click() =~
               "タスクを編集"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      # get updated task and update
      updated_task = Sup.recent_updated_task()
      update = His.get_latest_update()

      assert update.update["old"]["name"] == task.name
      assert update.update["new"]["name"] == updated_task.name

      assert html =~ "タスクの編集内容が保存されました"
    end

    test "add com to task", %{conn: conn, task: task, com: com} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live
            |> element("#task-#{task.id} a", "編集")
            |> render_click() =~ "タスクを編集"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task))

      assert index_live
            |> element("a", "対象の会社を追加")
            |> render_click()
      assert_redirected(index_live, "/coms?task_id=#{task.id}")

      # visit com with task id. ideally get redirected to here after clicking anchor tag with "Add Company"
      {:ok, com_view, _html} = live(conn, "/coms?task_id=#{task.id}")

      com_view
      |> element(~s{[href="/coms/#{com.id}/edit"]})
      |> render_click() =~ "選択中のタスクにこの会社を追加"

      {:ok, task_view, _html} =
        com_view
        |> element("a", "選択中のタスクにこの会社を追加")
        |> render_click()
        |> follow_redirect(conn, Routes.task_index_path(conn, :edit, task))

      # get updated task and update
      updated_task = Sup.recent_updated_task()
      update = His.get_latest_update()

      # Make sure updated appo has com's id
      assert update.update["old"]["com_id"] == nil
      assert updated_task.com_id == update.update["new"]["com_id"]
      assert updated_task.com_id == com.id

      refute has_element?(task_view, "a", "Add Company")
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "削除") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "search tasks" do
    setup [:create_many_tasks]

    test "searching random task for 20 times", %{conn: conn} do
      tasks = Sup.list_tasks()
      assert Enum.count(tasks) == 20

      {:ok, list_task, _html} = live(conn, Routes.task_index_path(conn, :index))

      Enum.each(1..20, fn _->
        task = Enum.random(tasks)
        searched_list = list_task
          |> form("#task-search", task_search: %{term: task.name})
          |> render_submit()

        assert searched_list =~ inspect(task.id)
        assert searched_list =~ String.replace(task.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ task.person_in_charge
        assert searched_list =~ Atom.to_string(task.priority)
      end)
    end
  end
end


## Add com to task
### 1. open edit modal for task
### 2. click 'Add com to task' link
### 3. redirected to com index page with task's id
### 4. click one com's edit link
### 5. com's edit modal appears and the modal has 'Add com to task' link so click it
### 6. update the com with task's id and redirected to task edit modal
### 7. make sure that there is com's name
