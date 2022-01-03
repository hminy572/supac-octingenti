defmodule Lv13.Sup.Appo do
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
      :Prospecting,
      :Qualification,
      :NeedsAnalysis,
      :ValueProposition,
      :IndentifyingDecisionMakers,
      :PerceptionAnalysis,
      :Proposal,
      :Negotiation,
      :ClosedWon,
      :ClosedLost
    ],
    default: :Prospecting
    belongs_to :com, Lv13.Sup.Com
    belongs_to :prod, Lv13.Sup.Prod

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
