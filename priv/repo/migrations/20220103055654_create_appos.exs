defmodule Lv13.Repo.Migrations.CreateAppos do
  use Ecto.Migration

  def change do
    create table(:appos) do
      add :name, :string, null: false
      add :state, :string, null: false
      add :amount, :integer, null: false
      add :probability, :integer, null: false
      add :description, :text, null: false
      add :is_client, :boolean, default: false, null: false
      add :date, :date, null: false
      add :person_in_charge, :string, null: false
      add :deleted_at, :naive_datetime
      add :com_id, references(:coms, on_delete: :nothing)
      add :prod_id, references(:prods, on_delete: :nothing)

      timestamps()
    end

    create index(:appos, [:com_id])
    create index(:appos, [:prod_id])
  end
end
