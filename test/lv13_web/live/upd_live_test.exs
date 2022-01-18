defmodule SupacWeb.UpdLiveTest do
  use SupacWeb.ConnCase

  import Phoenix.LiveViewTest
  #import Supac.HisFixtures

  setup :register_and_log_in_confirmed_user

  # @lead_create_attrs %{
  #   com_name: "some com_name",
  #   email: "some@email.com",
  #   name: "some name",
  #   position: Enum.random(Ecto.Enum.values(Lead, :position)),
  #   size: Enum.random(Ecto.Enum.values(Lead, :size)),
  #   state: :"見込み",
  #   url: "https://some.url"
  # }
  # @lead_update_attrs %{
  #   com_name: "some updated com_name",
  #   email: "some@updated.email",
  #   name: "lead name",
  #   position: Enum.random(Ecto.Enum.values(Lead, :position)),
  #   size: Enum.random(Ecto.Enum.values(Lead, :size)),
  #   state: :"見込み",
  #   url: "https://some_updated.url"
  # }
  # @appo_update_attrs %{
  #   amount: 43,
  #   date: Faker.Date.backward(10),
  #   description: "some updated description",
  #   is_clinet: false,
  #   name: "appo name",
  #   person_in_charge: "user1",
  #   probability: 456.7,
  #   state: Enum.random(Ecto.Enum.values(Appo, :state))
  # }
  # @com_update_attrs %{
  #   email: "some@updated.email",
  #   name: "com name",
  #   size: Enum.random(Ecto.Enum.values(Com, :size)),
  #   url: "http://some_updated.url"
  # }
  # @con_update_attrs %{
  #   email: "some@updated.email",
  #   name: "con name",
  #   position: Enum.random(Ecto.Enum.values(Con, :position))
  # }
  # @product_update_attrs %{name: "product name", price: 43}
  # @task_update_attrs %{
  #   content: "some updated content",
  #   due_date: Date.utc_today(),
  #   name: "task name",
  #   person_in_charge: "user1",
  #   priority: Enum.random(Ecto.Enum.values(Task, :priority))
  # }

  # defp create_lead(_) do
  #   lead = lead_fixture()
  #   %{lead: lead}
  # end

  # defp create_many(_) do
  #   %{
  #     lead: lead_fixture(),
  #     appo: appo_fixture(),
  #     com: com_fixture(),
  #     con: con_fixture(),
  #     product: product_fixture(),
  #     task: task_fixture()
  #   }
  # end

  describe "search updates" do
    # setup [:create_many]

    test "search update with empty fields", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.upd_index_path(conn, :index))

      update = %{
        from: "",
        to: "",
        term: ""
      }
      index_live |> form("#update-form", update: update) |> render_submit()
    end
  end
end
