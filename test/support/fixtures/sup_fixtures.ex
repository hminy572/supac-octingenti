defmodule Supac.SupFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Supac.Sup` context.
  """
  alias Supac.Sup.{Lead, Con, Com, Task}
  alias Supac.Repo

  @doc """
  Generate a lead.
  """
  def lead_fixture(attrs \\ %{}) do
    {:ok, lead} =
      attrs
      |> Enum.into(%{
        com_name: "some com_name",
        email: "some@email.com",
        name: "some name",
        position: Enum.random(Ecto.Enum.values(Lead, :position)),
        size: Enum.random(Ecto.Enum.values(Lead, :size)),
        state: :"見込み",
        url: "https://some.url"
      })
      |> Supac.Sup.create_lead()

    lead
  end

  @doc """
  Generate a com.
  """
  def com_fixture(attrs \\ %{}) do
    {:ok, com} =
      attrs
      |> Enum.into(%{
        email: Faker.Internet.email,
        name: Faker.Pokemon.name,
        size: Enum.random(Ecto.Enum.values(Com, :size)),
        url: "https://some.url"
      })
      |> Supac.Sup.create_com()

    Repo.preload(com, [:cons, :appos, :tasks])
  end

  @doc """
  Generate a prod.
  """
  def prod_fixture(attrs \\ %{}) do
    {:ok, prod} =
      attrs
      |> Enum.into(%{
        name: "some name",
        price: 42
      })
      |> Supac.Sup.create_prod()

    Repo.preload(prod, :appos)
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        content: Faker.Lorem.paragraph,
        due_date: Faker.Date.backward(10),
        name: Faker.Pokemon.name,
        person_in_charge: "user1",
        priority: Enum.random(Ecto.Enum.values(Task, :priority))
      })
      |> Supac.Sup.create_task()

    Repo.preload(task, :com)
  end

  @doc """
  Generate a con.
  """
  def con_fixture(attrs \\ %{}) do
    {:ok, con} =
      attrs
      |> Enum.into(%{
        email: Faker.Internet.email,
        name: Faker.Pokemon.name,
        position: Enum.random(Ecto.Enum.values(Con, :position))
      })
      |> Supac.Sup.create_con()

    Repo.preload(con, :com)
  end

  @doc """
  Generate a appo.
  """
  def appo_fixture(attrs \\ %{}) do
    {:ok, appo} =
      attrs
      |> Enum.into(%{
        amount: :rand.uniform(10) * 1000,
        date: Faker.Date.backward(10),
        description: Faker.Lorem.paragraph,
        is_client: true,
        name: Faker.Pokemon.name,
        probability: :rand.uniform(),
        person_in_charge: "user1",
        state: :"見込み",
      })
      |> Supac.Sup.create_appo()

    Repo.preload(appo, [:com, :prod])
  end
end
