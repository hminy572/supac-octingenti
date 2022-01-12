defmodule Supac.Sup.Prod do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prods" do
    field :deleted_at, :naive_datetime
    field :name, :string
    field :price, :integer
    has_many :appos, Supac.Sup.Appo

    timestamps()
  end

  @doc false
  def changeset(prod, attrs) do
    prod
    |> cast(attrs, [:name, :price])
    |> cast_assoc(:appos, required: false)
    |> validate_required([:name, :price])
  end

  @doc false
  def delete_changeset(prod, attrs) do
    prod
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
