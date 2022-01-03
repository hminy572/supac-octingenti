defmodule Lv13.SupFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lv13.Sup` context.
  """

  @doc """
  Generate a lead.
  """
  def lead_fixture(attrs \\ %{}) do
    {:ok, lead} =
      attrs
      |> Enum.into(%{
        com_name: "some com_name",
        deleted_at: ~N[2022-01-01 14:38:00],
        email: "some email",
        name: "some name",
        position: "some position",
        size: "some size",
        state: "some state",
        url: "some url"
      })
      |> Lv13.Sup.create_lead()

    lead
  end

  @doc """
  Generate a com.
  """
  def com_fixture(attrs \\ %{}) do
    {:ok, com} =
      attrs
      |> Enum.into(%{
        deleted_at: ~N[2022-01-02 05:22:00],
        email: "some email",
        name: "some name",
        size: "some size",
        url: "some url"
      })
      |> Lv13.Sup.create_com()

    com
  end

  @doc """
  Generate a prod.
  """
  def prod_fixture(attrs \\ %{}) do
    {:ok, prod} =
      attrs
      |> Enum.into(%{
        deleted_at: ~N[2022-01-02 05:32:00],
        name: "some name",
        price: 42
      })
      |> Lv13.Sup.create_prod()

    prod
  end

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        content: "some content",
        deleted_at: ~N[2022-01-02 05:34:00],
        due_date: ~N[2022-01-02 05:34:00],
        person_in_charge: "some person_in_charge",
        priority: "some priority"
      })
      |> Lv13.Sup.create_task()

    task
  end

  @doc """
  Generate a con.
  """
  def con_fixture(attrs \\ %{}) do
    {:ok, con} =
      attrs
      |> Enum.into(%{
        deleted_at: ~N[2022-01-02 05:39:00],
        email: "some email",
        name: "some name",
        position: "some position"
      })
      |> Lv13.Sup.create_con()

    con
  end

  @doc """
  Generate a appo.
  """
  def appo_fixture(attrs \\ %{}) do
    {:ok, appo} =
      attrs
      |> Enum.into(%{
        amount: 42,
        date: ~D[2022-01-02],
        deleted_at: ~N[2022-01-02 05:56:00],
        description: "some description",
        is_client: true,
        name: "some name",
        person_in_charge: "some person_in_charge",
        probability: 42,
        state: "some state"
      })
      |> Lv13.Sup.create_appo()

    appo
  end
end
