defmodule Supac.Sup.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :content, :string
    field :deleted_at, :naive_datetime
    field :due_date, :date
    field :name, :string
    field :person_in_charge, :string
    field :priority, Ecto.Enum, values: [:"緊急", :"急ぎ", :"なる早", :"時間がある時"], defautl: :"時間がある時"
    belongs_to :com, Supac.Sup.Com

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :due_date, :person_in_charge, :content, :priority, :com_id])
    |> validate_required([:name, :due_date, :person_in_charge, :content, :priority])
  end

  def delete_changeset(task, attrs) do
    task
    |> cast(attrs, [:deleted_at])
    |> validate_required([:deleted_at])
  end
end
