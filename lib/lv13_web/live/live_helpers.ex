defmodule Lv13Web.LiveHelpers do
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
          module={Lv13Web.LeadLive.FormComponent}
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
      <div
        id="modal-content"
        class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity flex justify-center"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <div class="overflow-auto h-full w-screen sm:w-11/12 md:w-9/12 lg:w-7/12 xl:w-5/12">
          <div class="m-5 p-5 border-4 border-amber-300 rounded-lg bg-white">
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
                <a id="close" href="#" class="" phx-click={hide_modal()}>✖</a>
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
    Lv13.His.create_upd(
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


# [error] GenServer #PID<0.19196.0> terminating
# ** (Protocol.UndefinedError) protocol Jason.Encoder not implemented for %Lv12.Supac.Com{__meta__: #Ecto.Schema.Metadata<:loaded, "coms">, appos: #Ecto.Association.NotLoaded<association :appos is not loaded>, cons: #Ecto.Association.NotLoaded<association :cons is not loaded>, deleted_at: nil, email: "edythe1902@kuhn.com", id: 47, inserted_at: ~N[2021-12-16 09:29:33], name: "Hagenes and Sons", size: :"100~300", tasks: #Ecto.Association.NotLoaded<association :tasks is not loaded>, updated_at: ~N[2021-12-16 09:29:33], url: "http://gorczany.com"} of type Lv12.Supac.Com (a struct), Jason.Encoder protocol must always be explicitly implemented.

# If you own the struct, you can derive the implementation specifying which fields should be encoded to JSON:

#     @derive {Jason.Encoder, only: [....]}
#     defstruct ...

# It is also possible to encode all fields, although this should be used carefully to avoid accidentally leaking private information when new fields are added:

#     @derive Jason.Encoder
#     defstruct ...

# Finally, if you don't own the struct you want to encode to JSON, you may use Protocol.derive/3 placed outside of any module:

#     Protocol.derive(Jason.Encoder, NameOfTheStruct, only: [...])
#     Protocol.derive(Jason.Encoder, NameOfTheStruct)
# . This protocol is implemented for the following type(s): Ecto.Association.NotLoaded, Ecto.Schema.Metadata, Date, BitString, Jason.Fragment, Any, Map, NaiveDateTime, List, Integer, Time, DateTime, Decimal, Atom, Float
#     (jason 1.2.2) lib/jason.ex:199: Jason.encode_to_iodata!/2
#     (postgrex 0.15.13) lib/postgrex/type_module.ex:897: Postgrex.DefaultTypes.encode_params/3
#     (postgrex 0.15.13) lib/postgrex/query.ex:75: DBConnection.Query.Postgrex.Query.encode/3
#     (db_connection 2.4.1) lib/db_connection.ex:1224: DBConnection.encode/5
#     (db_connection 2.4.1) lib/db_connection.ex:1324: DBConnection.run_prepare_execute/5
#     (db_connection 2.4.1) lib/db_connection.ex:1428: DBConnection.run/6
#     (db_connection 2.4.1) lib/db_connection.ex:593: DBConnection.parsed_prepare_execute/5
#     (db_connection 2.4.1) lib/db_connection.ex:585: DBConnection.prepare_execute/4
#     (postgrex 0.15.13) lib/postgrex.ex:292: Postgrex.query/4
#     (ecto_sql 3.7.1) lib/ecto/adapters/sql.ex:802: Ecto.Adapters.SQL.struct/10
#     (ecto 3.7.1) lib/ecto/repo/schema.ex:744: Ecto.Repo.Schema.apply/4
#     (ecto 3.7.1) lib/ecto/repo/schema.ex:367: anonymous fn/15 in Ecto.Repo.Schema.do_insert/4
#     (lv12 0.1.0) lib/lv12_web/live/con_live/form_component.ex:44: Lv12Web.ConLive.FormComponent.save_con/3
#     (phoenix_live_view 0.17.5) lib/phoenix_live_view/channel.ex:558: anonymous fn/4 in Phoenix.LiveView.Channel.inner_component_handle_event/4
#     (telemetry 1.0.0) /Users/araihiroki/elixir/lv12/deps/telemetry/src/telemetry.erl:293: :telemetry.span/3
#     (phoenix_live_view 0.17.5) lib/phoenix_live_view/diff.ex:206: Phoenix.LiveView.Diff.write_component/4
#     (phoenix_live_view 0.17.5) lib/phoenix_live_view/channel.ex:488: Phoenix.LiveView.Channel.component_handle_event/6
#     (stdlib 3.16.1) gen_server.erl:695: :gen_server.try_dispatch/4
#     (stdlib 3.16.1) gen_server.erl:771: :gen_server.handle_msg/6
#     (stdlib 3.16.1) proc_lib.erl:226: :proc_lib.init_p_do_apply/3
# Last message: %Phoenix.Socket.Message{event: "event", join_ref: "4", payload: %{"cid" => 1, "event" => "save", "type" => "form", "value" => "_method=put&_csrf_token=ZGVXByszBh0wHRQUFF0RCQQVezkDF2Ba1UciRjssEMGQK1aqc_0Agt42&con%5Bcom_id%5D=47&con%5Bname%5D=Ashton+Stark&con%5Bemail%5D=edythe1902%40kuhn.com&con%5Bposition%5D=team_leader"}, ref: "7", topic: "lv:phx-FsIUkaudWm5yhm3H"}
# State: %{components: {%{1 => {Lv12Web.ConLive.FormComponent, 55, %{__changed__: %{}, action: :edit, changeset: #Ecto.Changeset<action: :validate, changes: %{position: :team_leader}, errors: [], data: #Lv12.Supac.Con<>, valid?: true>, con: %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: %Lv12.Supac.Com{__meta__: #Ecto.Schema.Metadata<:loaded, "coms">, appos: #Ecto.Association.NotLoaded<association :appos is not loaded>, cons: #Ecto.Association.NotLoaded<association :cons is not loaded>, deleted_at: nil, email: "edythe1902@kuhn.com", id: 47, inserted_at: ~N[2021-12-16 09:29:33], name: "Hagenes and Sons", size: :"100~300", tasks: #Ecto.Association.NotLoaded<association :tasks is not loaded>, updated_at: ~N[2021-12-16 09:29:33], url: "http://gorczany.com"}, com_id: 47, deleted_at: nil, email: "edythe1902@kuhn.com", id: 55, inserted_at: ~N[2021-12-16 09:29:33], name: "Ashton Stark", position: :manager, updated_at: ~N[2021-12-19 06:04:05]}, current_user: #Lv12.Accounts.User<__meta__: #Ecto.Schema.Metadata<:loaded, "users">, confirmed_at: ~N[2021-12-10 15:29:56], email: "test3@test.com", id: 1, inserted_at: ~N[2021-12-10 15:29:00], name: "test3", updated_at: ~N[2021-12-17 15:43:36], ...>, flash: %{}, id: 55, myself: %Phoenix.LiveComponent.CID{cid: 1}, return_to: "/cons", title: "Edit Con"}, %{__changed__: %{}, root_view: Lv12Web.ConLive.Index}, {247108720368397985842706938255843284117, %{1 => {284520024108037091308211474844586832081, %{1 => {223359922200928140149675350120201197962, %{}}, 2 => {33267102831095203319213751074762927952, %{}}, 3 => {193868443500672168359124466002900922005, %{}}}}, 2 => {236997080077139475110265922399505993275, %{0 => {187482811055036620987860593223444223683, %{}}}}}}}}, %{Lv12Web.ConLive.FormComponent => %{55 => 1}}, 2}, join_ref: "4", serializer: Phoenix.Socket.V2.JSONSerializer, socket: #Phoenix.LiveView.Socket<assigns: %{__changed__: %{}, active_tab: :con, cand_coms: [], con: %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: %Lv12.Supac.Com{__meta__: #Ecto.Schema.Metadata<:loaded, "coms">, appos: #Ecto.Association.NotLoaded<association :appos is not loaded>, cons: #Ecto.Association.NotLoaded<association :cons is not loaded>, deleted_at: nil, email: "edythe1902@kuhn.com", id: 47, inserted_at: ~N[2021-12-16 09:29:33], name: "Hagenes and Sons", size: :"100~300", tasks: #Ecto.Association.NotLoaded<association :tasks is not loaded>, updated_at: ~N[2021-12-16 09:29:33], url: "http://gorczany.com"}, com_id: 47, deleted_at: nil, email: "edythe1902@kuhn.com", id: 55, inserted_at: ~N[2021-12-16 09:29:33], name: "Ashton Stark", position: :manager, updated_at: ~N[2021-12-19 06:04:05]}, cons: [%Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is not loaded>, com_id: 47, deleted_at: nil, email: "edythe1902@kuhn.com", id: 55, inserted_at: ~N[2021-12-16 09:29:33], name: "Ashton Stark", position: :manager, updated_at: ~N[2021-12-19 06:04:05]}, %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is not loaded>, com_id: 46, deleted_at: nil, email: "murphy.crist@gleichner.name", id: 54, inserted_at: ~N[2021-12-16 09:28:47], name: "Katelyn Bradtke", position: :team_leader, updated_at: ~N[2021-12-16 09:28:47]}, %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is not loaded>, com_id: 45, deleted_at: nil, email: "ludie.damore@hermiston.info", id: 53, inserted_at: ~N[2021-12-16 09:28:17], name: "Noelia Boehm", position: :team_leader, updated_at: ~N[2021-12-16 09:28:17]}, %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is not loaded>, com_id: 44, deleted_at: nil, email: "ludie.damore@hermiston.info", id: 52, inserted_at: ~N[2021-12-16 09:27:45], name: "Noelia Boehm", position: :team_leader, updated_at: ~N[2021-12-16 09:27:45]}, %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is not loaded>, com_id: 43, deleted_at: nil, email: "abe.kiehn@gerhold.org", id: 51, inserted_at: ~N[2021-12-16 09:26:17], name: "Ms. Catalina Kuhn III", position: :manager, updated_at: ~N[2021-12-16 09:26:17]}, %Lv12.Supac.Con{__meta__: #Ecto.Schema.Metadata<:loaded, "cons">, com: #Ecto.Association.NotLoaded<association :com is no (truncated)
