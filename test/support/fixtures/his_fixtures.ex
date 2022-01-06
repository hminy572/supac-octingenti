defmodule Lv13.HisFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Lv13.His` context.
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
      |> Lv13.His.create_upd()

    upd
  end
end
