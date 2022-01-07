defmodule Supac.Repo.Migrations.CreateName do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :due_date, :naive_datetime, null: false
      add :person_in_charge, :string, null: false
      add :content, :text, null: false
      add :priority, :string, null: false
      add :deleted_at, :naive_datetime
      add :com_id, references(:coms, on_delete: :nothing)

      timestamps()
    end

    create index(:tasks, [:com_id])
  end
end
