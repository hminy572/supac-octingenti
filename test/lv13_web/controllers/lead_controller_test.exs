defmodule SupacWeb.LeadControllerTest do
  use SupacWeb.ConnCase, async: true

  import Supac.SupFixtures
  import Supac.AccountsFixtures

  alias Supac.Sup.Lead

  defp create_lead(_) do
    lead = lead_fixture()
    %{lead: lead}
  end

  @doc """
  Setup helper that logs in and put request header which has basic auth header into conn

      setup :log_in_and_get_token

  It returns a conn with verified token
  """
  def log_in_and_get_token(%{conn: conn}) do
    user = Supac.AccountsFixtures.confirmed_user_fixture()
    conn = post(conn,
      Routes.user_api_session_path(conn, :create,
        %{
          email: user.email,
          password: valid_user_password()
        }
      )
    )
    %{"token" => token} = json_response(conn, 200)
    conn =
      conn
      |> recycle()
      |> put_req_header("accept", "application/json") # fail without this
      |> put_req_header("authorization", "Bearer #{token}")

    %{conn: conn, user: user}
  end

  @create_attrs %{
    name: "some name",
    email: "some@email.come",
    com_name: "some com name",
    state: Enum.random(Ecto.Enum.values(Lead, :state)),
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    url: "http://some.url"
  }

  @invalid_attrs %{
    name: nil,
    email: nil,
    com_name: nil,
    state: Enum.random(Ecto.Enum.values(Lead, :state)),
    position: Enum.random(Ecto.Enum.values(Lead, :position)),
    size: Enum.random(Ecto.Enum.values(Lead, :size)),
    url: nil
  }

  describe "verify json response for lead works fine" do
    setup [:create_lead, :log_in_and_get_token]

    test "index lead", %{conn: conn, user: user, lead: lead} do

      conn = get(conn, Routes.user_api_session_path(conn, :status))

      assert %{"status" => status} = json_response(conn, 200)
      assert status == "#{user.email} enable"

      conn = get(conn, Routes.lead_path(conn, :index))
      assert [%{
          "id" => lead_id,
          "name" => lead_name,
          "email" => _email,
          "com_name" => _com_name,
          "state" => _state,
          "position" => _position,
          "size" => _size,
          "url" => _url
        }] = json_response(conn, 200)["data"]
      assert lead_id == lead.id
      assert lead_name == lead.name
    end

    test "renders lead when data is valid", %{conn: conn} do
      conn = post(conn, Routes.lead_path(conn, :create), lead: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.lead_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.lead_path(conn, :create), lead: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

end
