defmodule Supac.Repo.Migrations.CreateUpds do
  use Ecto.Migration

  def change do
    create table(:upds) do
      add :update, :map, null: false, default: %{}

      timestamps()
    end
  end
end
