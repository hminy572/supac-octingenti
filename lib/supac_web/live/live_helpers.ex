defmodule SupacWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.lead_index_path(@socket, :index)}>
        <.live_component
          module={SupacWeb.LeadLive.FormComponent}
          id={@lead.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.lead_index_path(@socket, :index)}
          lead: @lead
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="" phx-remove={hide_modal()}>
      <div id="modal-content" class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity flex justify-center">
        <div class="overflow-auto h-full w-screen sm:w-11/12 md:w-9/12 lg:w-7/12 xl:w-5/12">
          <div
            phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
            class="m-5 p-5 border-4 border-amber-300 rounded-lg bg-white">
            <%= if @return_to do %>

              <div class="flex justify-between">
                <div></div>
                <%= live_patch "✖",
                  to: @return_to,
                  id: "close",
                  class: "text-2xl",
                  phx_click: hide_modal()
                %>
              </div>
            <% else %>
              <div class="flex justify-between">
                <div></div>
                <a id="close" href="#" class="" phx-click={hide_modal()} phx-click-away={hide_modal()}>✖</a>
              </div>
            <% end %>

            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  @doc """
  Creates an update that has username, schema name, old version, and new version
  """
  def create_an_update(old, new, user) do
    Supac.His.create_upd(
      %{
        update: %{
          user: %{user_name: user.name, email: user.email},
          schema: schema_name(new),
          old: struct_to_map(old),
          new: struct_to_map(new)
        }
      }
    )
  end

  defp struct_to_map(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.replace(:com, nil)
    |> Map.replace(:prod, nil)
    |> Map.replace(:cons, nil)
    |> Map.replace(:appos, nil)
    |> Map.replace(:tasks, nil)

    # Makes preloaded structs nil.
    # If update includes struct inside, it raises an error like shown below
  end

  defp schema_name(struct) do
    struct.__struct__
    |> Module.split()
    |> Enum.join(".")
  end

  # returns a Map that has removed info about diff
  # between the given two maps like something shown below

  #   %{
  #     "position" => "staff",
  #     "size" => "30~50",
  #     "updated_at" => "2021-11-06T08:47:52"
  #   }
  # }
  defp diff_removed(update) do
    old = update.update["old"]
    new = update.update["new"]
    diff = MapDiff.diff(old, new)
    diff_removed = diff.removed
    Map.drop(diff_removed, ["updated_at"])
  end


  # the struct that MpDiff return has added key and removed key, where added corresponds new value and removed corresponds old value

  #   %{
  #     "position" => "team_leader",
  #     "size" => "5~30",
  #     "updated_at" => "2021-11-08T08:02:39"
  #   }

  # }
  defp diff_added(update) do
    Map.drop(
      MapDiff.diff(
        update.update["old"],
        update.update["new"]
        ).added,
      ["updated_at"]
    )
  end

  def updated_keys(update) do
    update
    |> diff_removed()
    |> Map.keys()
  end

  def old_values(update) do
    update
    |> diff_removed()
    |> Map.values()
  end

  def new_values(update) do
    update
    |> diff_added()
    |> Map.values()
  end
end
