defmodule Supac.Sup.Lead do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leads" do
    field :com_name, :string
    field :deleted_at, :naive_datetime
    field :email, :string
    field :name, :string
    field :position, Ecto.Enum,
      values: [
        :"CEO",
        :"マネージャー",
        :"主任",
        :"一般社員"
        ],
      default: :"一般社員"
    field :size, Ecto.Enum,
      values: [
        {:"1~5", "1~5"},
        {:"5~30", "5~30"},
        {:"30~50", "30~50"},
        {:"50~100", "50~100"},
        {:"100~300", "100~300"},
        {:"300~", "300~"}
      ], default: :"1~5"
    field :state, Ecto.Enum,
      values: [
        :"見込み",
        :"連絡済み",
        :"日程調整中",
        :"案件化"
      ], default: :"見込み"
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(lead, attrs) do
    lead
    |> cast(attrs, [:name, :email, :com_name, :state, :position, :size, :url])
    |> validate_required([:name, :email, :com_name, :state, :position, :size, :url])
    |> validate_format(:email, ~r/(.{3,})@(.+)\.(.+)/, message: "format should be like atleast3chars@yy.com")
    |> validate_format(:url, ~r/^(https|http):\/\/.*/, message: "invalid URL :(")
  end

  @doc false
  def delete_changeset(lead, attrs) do
    lead
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
