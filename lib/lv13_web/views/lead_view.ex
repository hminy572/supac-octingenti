defmodule Lv13Web.LeadView do
  use Lv13Web, :view
  alias Lv13Web.LeadView

  def render("index.json", %{leads: leads}) do
    %{data: render_many(leads, LeadView, "lead.json")}
  end

  def render("show.json", %{lead: lead}) do
    %{data: render_one(lead, LeadView, "lead.json")}
  end

  def render("lead.json", %{lead: lead}) do
    %{
      id: lead.id,
      name: lead.name,
      email: lead.email,
      com_name: lead.com_name,
      state: lead.state,
      position: lead.position,
      size: lead.size,
      url: lead.url
    }
  end
end
