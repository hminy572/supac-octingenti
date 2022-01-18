defmodule Supac.Sup.Appo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appos" do
    field :amount, :integer
    field :date, :date
    field :deleted_at, :naive_datetime
    field :description, :string
    field :is_client, :boolean, default: false
    field :name, :string
    field :person_in_charge, :string
    field :probability, :float
    field :state, Ecto.Enum, values: [
      :"見込み",
      :"決済者打診中",
      :"提案中",
      :"交渉中",
      :"成約",
      :"失注"
    ],
    default: :"見込み"
    belongs_to :com, Supac.Sup.Com
    belongs_to :prod, Supac.Sup.Prod

    timestamps()
  end

  @doc false
  def changeset(appo, attrs) do
    appo
    |> cast(attrs, [:name, :state, :amount, :probability, :description, :is_client, :person_in_charge, :date, :com_id, :prod_id])
    |> validate_required([:name, :state, :amount, :probability, :description, :is_client, :person_in_charge, :date])
  end

  @doc false
  def delete_changeset(appo, attrs) do
    appo
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
