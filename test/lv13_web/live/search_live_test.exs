defmodule Lv13Web.SearchLiveTest do
  use Lv13Web.ConnCase, async: true

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures
  alias Lv13Web.SearchLive
  alias Lv13.Sup

  setup :register_and_log_in_confirmed_user

  defp create_each(_) do
    %{
      appo: appo_fixture(),
      com: com_fixture(),
      con: con_fixture(),
      lead: lead_fixture(),
      prod: prod_fixture(),
      task: task_fixture()
    }
  end

  describe "Sup.search test" do
    setup [:create_each]

    test "all results", %{
      appo: appo,
      com: com,
      con: con,
      lead: lead,
      prod: prod,
      task: task
    } do
      res = Sup.search("")
      assert Enum.at(res.appos, 0).name == appo.name
      assert Enum.at(res.coms, 0).name == com.name
      assert Enum.at(res.cons, 0).name == con.name
      assert Enum.at(res.leads, 0).name == lead.name
      assert Enum.at(res.prods, 0).name == prod.name
      assert Enum.at(res.tasks, 0).name == task.name
    end

  end

  describe "test all search results" do
    setup [:create_each]

    test "check if all kinds of objects are rendered", %{
      conn: conn,
      appo: appo,
      com: com,
      con: con,
      lead: lead,
      prod: prod,
      task: task
    } do
      {:ok, _view, html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      assert html =~ "search_term: "
      assert html =~ "Appointment"
      assert html =~ appo.name
      assert html =~ "Company"
      assert html =~ com.name
      assert html =~ "Contact"
      assert html =~ con.name
      assert html =~ "Lead"
      assert html =~ lead.name
      assert html =~ "Prod"
      assert html =~ prod.name
      assert html =~ "Task"
      assert html =~ task.name
    end

    test "redirect to appo", %{conn: conn, appo: appo} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, appo_view, appo_html} = view
        |> element("#appo-#{appo.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.appo_index_path(conn, :edit, appo))

      assert appo_html =~ "Edit Appo"
      assert appo_view |> element("#appo-form_name") |> render() =~ String.replace(appo.name, "'", "&#39;")
    end

    test "redirect to com", %{conn: conn, com: com} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, com_view, com_html} = view
        |> element("#com-#{com.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.com_index_path(conn, :edit, com))

      assert com_html =~ "Edit Com"
      assert com_view |> element("#com-form_name") |> render() =~ String.replace(com.name, "'", "&#39;")
    end

    test "redirect to con", %{conn: conn, con: con} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, con_view, con_html} = view
        |> element("#con-#{con.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.con_index_path(conn, :edit, con))

      assert con_html =~ "Edit Con"
      assert con_view |> element("#con-form_name") |> render() =~ String.replace(con.name, "'", "&#39;")
    end

    test "redirect to lead", %{conn: conn, lead: lead} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, lead_view, lead_html} = view
        |> element("#lead-#{lead.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.lead_index_path(conn, :edit, lead))

      assert lead_html =~ "Edit Lead"
      assert lead_view |> element("#lead-form_name") |> render() =~ lead.name
    end

    test "redirect to prod", %{conn: conn, prod: prod} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, prod_view, prod_html} = view
        |> element("#prod-#{prod.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.prod_index_path(conn, :edit, prod))

      assert prod_html =~ "Edit Prod"
      assert prod_view |> element("#prod-form_name") |> render() =~ prod.name
    end

    test "redirect to task", %{conn: conn, task: task} do
      {:ok, view, _html} = live(conn, Routes.live_path(conn, SearchLive, term: ""))

      {:ok, task_view, task_html} = view
        |> element("#task-#{task.id}")
        |> render_click()
        |> follow_redirect(conn, Routes.task_index_path(conn, :edit, task))

      assert task_html =~ "Edit Task"
      assert task_view |> element("#task-form_name") |> render() =~ String.replace(task.name, "'", "&#39;")
    end

    test "no results found", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.live_path(conn, SearchLive, term: "å≈ç√√∫"))

      assert html =~ "search_term: å≈ç√√∫"
      assert html =~ "no results found"
    end
  end
end
