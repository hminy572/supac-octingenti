defmodule Lv13Web.TaskLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures

  @create_attrs %{content: "some content", deleted_at: %{day: 2, hour: 5, minute: 34, month: 1, year: 2022}, due_date: %{day: 2, hour: 5, minute: 34, month: 1, year: 2022}, person_in_charge: "some person_in_charge", priority: "some priority"}
  @update_attrs %{content: "some updated content", deleted_at: %{day: 3, hour: 5, minute: 34, month: 1, year: 2022}, due_date: %{day: 3, hour: 5, minute: 34, month: 1, year: 2022}, person_in_charge: "some updated person_in_charge", priority: "some updated priority"}
  @invalid_attrs %{content: nil, deleted_at: %{day: 30, hour: 5, minute: 34, month: 2, year: 2022}, due_date: %{day: 30, hour: 5, minute: 34, month: 2, year: 2022}, person_in_charge: nil, priority: nil}

  defp create_task(_) do
    task = task_fixture()
    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all name", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Listing Name"
      assert html =~ task.content
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, Routes.task_index_path(conn, :new))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task created successfully"
      assert html =~ "some content"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, Routes.task_index_path(conn, :edit, task))

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_index_path(conn, :index))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, Routes.task_index_path(conn, :index))

      assert index_live |> element("#task-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Show Task"
      assert html =~ task.content
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, Routes.task_show_path(conn, :show, task))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, Routes.task_show_path(conn, :edit, task))

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "is invalid"

      {:ok, _, html} =
        show_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.task_show_path(conn, :show, task))

      assert html =~ "Task updated successfully"
      assert html =~ "some updated content"
    end
  end
end
