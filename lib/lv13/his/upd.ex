defmodule Lv13.His.Upd do
  use Ecto.Schema
  import Ecto.Changeset

  schema "upds" do
    field :update, :string

    timestamps()
  end

  @doc false
  def changeset(upd, attrs) do
    upd
    |> cast(attrs, [:update])
    |> validate_required([:update])
  end
end
