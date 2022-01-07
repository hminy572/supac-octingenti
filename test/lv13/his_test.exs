defmodule Supac.HisTest do
  use Supac.DataCase

  alias Supac.His

  describe "upds" do
    alias Supac.His.Upd

    import Supac.HisFixtures

    @invalid_attrs %{update: nil}

    test "list_upds/0 returns all upds" do
      upd = upd_fixture()
      assert His.list_upds() == [upd]
    end

    test "get_upd!/1 returns the upd with given id" do
      upd = upd_fixture()
      assert His.get_upd!(upd.id) == upd
    end

    test "create_upd/1 with valid data creates a upd" do
      valid_attrs = %{update: %{}}

      assert {:ok, %Upd{} = upd} = His.create_upd(valid_attrs)
      assert upd.update == %{}
    end

    test "create_upd/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = His.create_upd(@invalid_attrs)
    end

    test "update_upd/2 with valid data updates the upd" do
      upd = upd_fixture()
      update_attrs = %{update: %{}}

      assert {:ok, %Upd{} = upd} = His.update_upd(upd, update_attrs)
      assert upd.update == %{}
    end

    test "update_upd/2 with invalid data returns error changeset" do
      upd = upd_fixture()
      assert {:error, %Ecto.Changeset{}} = His.update_upd(upd, @invalid_attrs)
      assert upd == His.get_upd!(upd.id)
    end

    test "delete_upd/1 deletes the upd" do
      upd = upd_fixture()
      assert {:ok, %Upd{}} = His.delete_upd(upd)
      assert_raise Ecto.NoResultsError, fn -> His.get_upd!(upd.id) end
    end

    test "change_upd/1 returns a upd changeset" do
      upd = upd_fixture()
      assert %Ecto.Changeset{} = His.change_upd(upd)
    end
  end
end
