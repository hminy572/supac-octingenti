defmodule Lv13.Repo.Migrations.CreateLeads do
  use Ecto.Migration

  def change do
    create table(:leads) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :com_name, :string, null: false
      add :state, :string, null: false
      add :position, :string, null: false
      add :size, :string, null: false
      add :url, :string, null: false
      add :deleted_at, :naive_datetime

      timestamps()
    end
  end
end
