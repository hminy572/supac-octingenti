defmodule Lv13.Repo.Migrations.CreateCons do
  use Ecto.Migration

  def change do
    create table(:cons) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :position, :string, null: false
      add :deleted_at, :naive_datetime
      add :com_id, references(:coms, on_delete: :nothing)

      timestamps()
    end

    create index(:cons, [:com_id])
  end
end
