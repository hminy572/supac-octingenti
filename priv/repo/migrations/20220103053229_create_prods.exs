defmodule Lv13.Repo.Migrations.CreateProds do
  use Ecto.Migration

  def change do
    create table(:prods) do
      add :name, :string, null: false
      add :price, :integer, null: false
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
