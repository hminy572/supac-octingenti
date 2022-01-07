defmodule Supac.Repo.Migrations.TaskDueDate do
  use Ecto.Migration

  def change do
    alter table("tasks") do
      modify :due_date, :date
    end
  end
end
