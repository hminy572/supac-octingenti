defmodule Supac.Sup.Con do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cons" do
    field :deleted_at, :naive_datetime
    field :email, :string
    field :name, :string
    field :position, Ecto.Enum,
      values: [
        :ceo,
        :manager,
        :team_leader,
        :staff
        ],
      default: :staff
    belongs_to :com, Supac.Sup.Com

    timestamps()
  end

  @doc false
  def changeset(con, attrs) do
    con
    |> cast(attrs, [:name, :email, :position, :com_id])
    |> validate_required([:name, :email, :position])
    |> validate_format(:email, ~r/(.{3,})@(.+)\.(.+)/, message: "format should be like atleast3chars@yy.com")
  end

  @doc false
  def delete_changeset(con, attrs) do
    con
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
