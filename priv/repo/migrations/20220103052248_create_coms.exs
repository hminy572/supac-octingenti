defmodule Lv13.Repo.Migrations.CreateComs do
  use Ecto.Migration

  def change do
    create table(:coms) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :url, :string, null: false
      add :size, :string, null: false
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
