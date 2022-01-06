defmodule Lv13Web.LeadLiveTest do
  use Lv13Web.ConnCase

  import Phoenix.LiveViewTest
  import Lv13.SupFixtures
  alias Lv13.Sup
  alias Lv13.His
  alias Lv13.Sup.Lead

  setup :register_and_log_in_confirmed_user

  @create_attrs %{
    com_name: "some com_name",
    email: "some@email.com",
    name: "some name",
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    state: :not_contacted,
    url: "https://some.url"
  }
  @update_attrs %{
    com_name: "some updated com_name",
    email: "some@updated.email",
    name: "some name",
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    state: :not_contacted,
    url: "https://some.url"
  }
  @converted_attrs %{
    com_name: "some updated com_name",
    email: "some@updated.email",
    name: "some name",
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    state: :converted,
    url: "https://some.url"
  }
  @invalid_attrs %{
    com_name: nil,
    email: nil,
    name: nil,
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    state: :not_contacted,
    url: "invalid url"
  }

  defp create_lead(_) do
    lead = lead_fixture()
    %{lead: lead}
  end

  defp create_appo(_) do
    appo = appo_fixture()
    %{appo: appo}
  end

  defp create_many_leads(_) do
    Enum.each(1..20, fn _ ->
      create_lead(%{
        name: Faker.Pokemon.name,
        email: Faker.Internet.email,
        com_name: Faker.Company.name,
        state: Enum.random(Ecto.Enum.values(Lead, :state)),
        position: Enum.random(Ecto.Enum.values(Lead, :position)),
        size: Enum.random(Ecto.Enum.values(Lead, :size)),
        url: Faker.Internet.url
      })
    end)
  end

  describe "Index" do
    setup [:create_lead, :create_appo]

    test "lists all leads", %{conn: conn, lead: lead} do
      {:ok, _index_live, html} = live(conn, Routes.lead_index_path(conn, :index))

      assert html =~ "New Lead"
      assert html =~ lead.com_name
    end

    test "saves new lead", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.lead_index_path(conn, :index))

      assert index_live
            |> element("a", "New Lead")
            |> render_click() =~ "New Lead"

      assert_patch(index_live, Routes.lead_index_path(conn, :new))

      assert index_live
             |> form("#lead-form", lead: @invalid_attrs)
             |> render_change() =~ "invalid"

      {:ok, _, html} =
        index_live
        |> form("#lead-form", lead: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lead_index_path(conn, :index))

      assert html =~ "Lead created successfully"
      assert html =~ "some com_name"
    end

    test "updates lead in listing", %{conn: conn, lead: lead} do
      # visit "/leads"
      {:ok, index_live, _html} = live(conn, Routes.lead_index_path(conn, :index))

      # open edit modal for lead
      assert index_live
            |> element("#lead-#{lead.id} a", "Edit")
            |> render_click() =~ "Edit Lead"

      assert_patch(index_live, Routes.lead_index_path(conn, :edit, lead))

      # can not update lead with invalid attrs
      assert index_live
             |> form("#lead-form", lead: @invalid_attrs)
             |> render_change() =~ "invalid"

      # update lead with valid attrs
      {:ok, _updated_live, html} =
        index_live
        |> form("#lead-form", lead: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.lead_index_path(conn, :index))

      assert html =~ "Lead updated successfully"
      assert html =~ "some updated com_name"

      # get updated_lead and update
      updated_lead = Sup.recent_updated_lead()
      update = His.get_latest_update()

      # assert pre update lead value
      assert update.update["old"]["email"] == lead.email
      assert update.update["old"]["com_name"] == lead.com_name

      # assert post update lead value
      assert update.update["new"]["email"] == updated_lead.email
      assert update.update["new"]["com_name"] == updated_lead.com_name
    end

    test "updates lead state to 'converted'", %{conn: conn, lead: lead, appo: appo} do
      # visit "/leads"
      {:ok, index_live, _html} = live(conn, Routes.lead_index_path(conn, :index))

      # open edit modal
      assert index_live
            |> element("#lead-#{lead.id} a", "Edit")
            |> render_click() =~ "Edit Lead"

      # update lead with %{state :converted} and get redirected to "/appos/:id/edit"
      {:ok, appo_live, html} =
        index_live
        |> form("#lead-form", lead: @converted_attrs)
        |> render_submit()
        |> follow_redirect(conn, "/appos/#{appo.id + 1}/edit")

      # get updated_lead and update
      updated_lead = Sup.recent_updated_lead()
      update = His.get_latest_update()

      # check if view has appointment name, lead's com_name, lead's email
      assert html =~ "first appointment with #{updated_lead.com_name}" # appo name includes lead's name
      assert has_element?(appo_live, "a", updated_lead.com_name) # link element to the com has com_name value
      assert has_element?(appo_live, "a", updated_lead.email) # link element to the con has email value

      # assert pre update lead value
      assert update.update["old"]["state"] == "not_contacted" # fails if :not_contacted

      # assert post update lead value
      assert update.update["new"]["state"] == "converted" # fails if :converted
    end

    test "deletes lead in listing", %{conn: conn, lead: lead} do
      {:ok, index_live, _html} = live(conn, Routes.lead_index_path(conn, :index))

      assert index_live |> element("#lead-#{lead.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#lead-#{lead.id}")
    end
  end

  describe "search leads" do
    setup [:create_many_leads]

    test "searching random lead for 20 times", %{conn: conn} do
      leads = Sup.list_leads()
      assert Enum.count(leads) == 20

      {:ok, list_lead, _html} = live(conn, Routes.lead_index_path(conn, :index))

      Enum.each(1..20, fn _->
        lead = Enum.random(leads)
        searched_list = list_lead
          |> form("#lead-search", lead_search: %{term: lead.name})
          |> render_submit()

        assert searched_list =~ inspect(lead.id)
        assert searched_list =~ String.replace(lead.name, "'", "&#39;") # ' -> &#39;
        assert searched_list =~ lead.com_name
        assert searched_list =~ Atom.to_string(lead.position)
        assert searched_list =~ Atom.to_string(lead.size)
      end)
    end
  end

end


## updated lead when state is not converted
### 1. open edit modal (already tested)
### 2. update lead
## updated lead when state is converted
### 1. open edit modal
### 2. update lead with state == "converted"
### 3. new com, con and appo are created and redirected to appo
### 4. make surea that appo has com and con with the lead values
