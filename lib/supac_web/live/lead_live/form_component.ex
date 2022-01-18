defmodule SupacWeb.LeadLive.FormComponent do
  use SupacWeb, :live_component

  alias Supac.Sup

  require Logger

  @impl true
  def update(%{lead: lead} = assigns, socket) do
    changeset = Sup.change_lead(lead)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"lead" => lead_params}, socket) do
    changeset =
      socket.assigns.lead
      |> Sup.change_lead(lead_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"lead" => lead_params}, socket) do
    save_lead(socket, socket.assigns.action, lead_params)
  end

  # Saves update based on changes.
  # When changes include %{state: :converted}, you are redirected to edit page of newly created appointment.
  defp save_lead(socket, :edit, lead_params) do
    # Logger.info(inspect(Map.has_key?(socket.assigns.changeset.changes, :state)))
    # Logger.info(inspect(socket.assigns.changeset.changes.state == :converted))

    if lead_params["state"] == "converted" do
      Logger.info("converted")
      case Sup.update_lead(socket.assigns.lead, lead_params) do
        {:ok, lead} ->
          com_params = com_params(lead)
          case Sup.create_com(com_params) do
            {:ok, com} ->
              case create_an_update(
                  socket.assigns.lead, # old one
                  lead, # new one
                  socket.assigns.current_user) do

                {:ok, _} ->
                  {:noreply,
                    socket
                    |> put_flash(:info, "Lead updated successfully and new company has just created along with new appo, contact!")
                    |> push_redirect(to: "/appos/#{Enum.at(com.appos, 0).id}/edit")
                  }

                {:error, %Ecto.Changeset{} = changeset} ->
                  {:noreply, assign(socket, :changeset, changeset)}
              end

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, socket
                |> assign(:changeset, changeset)
                |> put_flash(:error, "Lead updated successfully but couldn't create new company.")
              }
          end

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    else
      case Sup.update_lead(socket.assigns.lead, lead_params) do
        {:ok, lead} ->
          case create_an_update(
              socket.assigns.lead, # old one
              lead, # new one
              socket.assigns.current_user) do

            {:ok, _} ->
              Logger.info("not converted")
              {:noreply,
                socket
                |> put_flash(:info, "リードの編集内容が保存されました")
                |> push_redirect(to: socket.assigns.return_to)
              }

            {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, assign(socket, :changeset, changeset)}
          end

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign(socket, :changeset, changeset)}
      end
    end
  end

  defp save_lead(socket, :new, lead_params) do
    case Sup.create_lead(lead_params) do
      {:ok, _lead} ->
        {:noreply,
         socket
         |> put_flash(:info, "新規リードが作成されました")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp com_params(lead) do
    %{
      name: lead.com_name,
      email: lead.email,
      url: lead.url,
      size: lead.size,
      cons: [%{
        name: lead.name,
        email: lead.email,
        position: lead.position
      }],
      appos: [%{
        name: "first appointment with #{lead.com_name}",
        date: Date.utc_today(),
        state: :Prospecting,
        amount: 1,
        probability: 0.5,
        description: "first appointment with #{lead.com_name}",
        is_client: false,
        person_in_charge: Enum.at(Supac.Accounts.list_users_by_name(), 0)
      }]
    }
  end
end
