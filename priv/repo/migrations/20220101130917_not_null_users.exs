defmodule Supac.Repo.Migrations.NotNullUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      modify :name, :string, null: false
      modify :email, :string, null: false
    end
  end
end
