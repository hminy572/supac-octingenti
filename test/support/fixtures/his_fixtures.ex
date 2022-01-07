defmodule Supac.HisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Supac.His` context.
  """

  @doc """
  Generate a upd.
  """
  def upd_fixture(attrs \\ %{}) do
    {:ok, upd} =
      attrs
      |> Enum.into(%{
        update: %{}
      })
      |> Supac.His.create_upd()

    upd
  end
end
