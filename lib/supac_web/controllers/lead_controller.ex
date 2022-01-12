defmodule SupacWeb.LeadController do
  use SupacWeb, :controller

  alias Supac.Sup
  alias Supac.Sup.Lead

  action_fallback SupacWeb.FallbackController

  # index
  def index(conn, _params) do
    leads = Sup.list_leads()
    render(conn, "index.json", leads: leads)
  end

  # create
  def create(conn, %{"lead" => lead_params}) do
    with {:ok, %Lead{} = lead} <- Sup.create_lead(lead_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.lead_path(conn, :show, lead))
      |> render("show.json", lead: lead)
    end
  end

  #show
  def show(conn, %{"id" => id}) do
    lead = Sup.get_lead!(id)
    render(conn, "show.json", lead: lead)
  end
end
