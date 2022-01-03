defmodule Lv13.Sup.Com do
  use Ecto.Schema
  import Ecto.Changeset

  schema "coms" do
    field :deleted_at, :naive_datetime
    field :email, :string
    field :name, :string
    field :size, Ecto.Enum,
    values: [
      {:"1~5", "1~5"},
      {:"5~30", "5~30"},
      {:"30~50", "30~50"},
      {:"50~100", "50~100"},
      {:"100~300", "100~300"},
      {:"300~", "300~"}
    ],
    default: :"1~5"
    field :url, :string
    has_many :cons, Lv13.Sup.Con
    has_many :appos, Lv13.Sup.Appo
    has_many :tasks, Lv13.Sup.Task

    timestamps()
  end

  @doc false
  def changeset(com, attrs) do
    com
    |> cast(attrs, [:name, :email, :url, :size])
    |> cast_assoc(:cons, required: false)
    |> cast_assoc(:appos, requierd: false)
    |> cast_assoc(:tasks, requierd: false)
    |> validate_required([:name, :email, :url, :size])
    |> validate_format(:email, ~r/(.{3,})@(.+)\.(.+)/, message: "format should be like atleast3chars@yy.com")
    |> validate_format(:url, ~r/^(https|http):\/\/.*/, message: "invalid URL :(")
  end

  @doc false
  def delete_changeset(com, attrs) do
    com
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
