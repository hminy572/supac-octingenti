defmodule Lv13.Repo.Migrations.AppoProbability do
  use Ecto.Migration

  def change do
    alter table("appos") do
      modify :probability, :float
    end
  end
end
