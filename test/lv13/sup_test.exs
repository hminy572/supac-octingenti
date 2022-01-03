defmodule Lv13.SupTest do
  use Lv13.DataCase

  alias Lv13.Sup

  describe "leads" do
    alias Lv13.Sup.Lead

    import Lv13.SupFixtures

    @invalid_attrs %{com_name: nil, deleted_at: nil, email: nil, name: nil, position: nil, size: nil, state: nil, url: nil}

    test "list_leads/0 returns all leads" do
      lead = lead_fixture()
      assert Sup.list_leads() == [lead]
    end

    test "get_lead!/1 returns the lead with given id" do
      lead = lead_fixture()
      assert Sup.get_lead!(lead.id) == lead
    end

    test "create_lead/1 with valid data creates a lead" do
      valid_attrs = %{com_name: "some com_name", deleted_at: ~N[2022-01-01 14:38:00], email: "some email", name: "some name", position: "some position", size: "some size", state: "some state", url: "some url"}

      assert {:ok, %Lead{} = lead} = Sup.create_lead(valid_attrs)
      assert lead.com_name == "some com_name"
      assert lead.deleted_at == ~N[2022-01-01 14:38:00]
      assert lead.email == "some email"
      assert lead.name == "some name"
      assert lead.position == "some position"
      assert lead.size == "some size"
      assert lead.state == "some state"
      assert lead.url == "some url"
    end

    test "create_lead/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_lead(@invalid_attrs)
    end

    test "update_lead/2 with valid data updates the lead" do
      lead = lead_fixture()
      update_attrs = %{com_name: "some updated com_name", deleted_at: ~N[2022-01-02 14:38:00], email: "some updated email", name: "some updated name", position: "some updated position", size: "some updated size", state: "some updated state", url: "some updated url"}

      assert {:ok, %Lead{} = lead} = Sup.update_lead(lead, update_attrs)
      assert lead.com_name == "some updated com_name"
      assert lead.deleted_at == ~N[2022-01-02 14:38:00]
      assert lead.email == "some updated email"
      assert lead.name == "some updated name"
      assert lead.position == "some updated position"
      assert lead.size == "some updated size"
      assert lead.state == "some updated state"
      assert lead.url == "some updated url"
    end

    test "update_lead/2 with invalid data returns error changeset" do
      lead = lead_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_lead(lead, @invalid_attrs)
      assert lead == Sup.get_lead!(lead.id)
    end

    test "delete_lead/1 deletes the lead" do
      lead = lead_fixture()
      assert {:ok, %Lead{}} = Sup.delete_lead(lead)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_lead!(lead.id) end
    end

    test "change_lead/1 returns a lead changeset" do
      lead = lead_fixture()
      assert %Ecto.Changeset{} = Sup.change_lead(lead)
    end
  end

  describe "coms" do
    alias Lv13.Sup.Com

    import Lv13.SupFixtures

    @invalid_attrs %{deleted_at: nil, email: nil, name: nil, size: nil, url: nil}

    test "list_coms/0 returns all coms" do
      com = com_fixture()
      assert Sup.list_coms() == [com]
    end

    test "get_com!/1 returns the com with given id" do
      com = com_fixture()
      assert Sup.get_com!(com.id) == com
    end

    test "create_com/1 with valid data creates a com" do
      valid_attrs = %{deleted_at: ~N[2022-01-02 05:22:00], email: "some email", name: "some name", size: "some size", url: "some url"}

      assert {:ok, %Com{} = com} = Sup.create_com(valid_attrs)
      assert com.deleted_at == ~N[2022-01-02 05:22:00]
      assert com.email == "some email"
      assert com.name == "some name"
      assert com.size == "some size"
      assert com.url == "some url"
    end

    test "create_com/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_com(@invalid_attrs)
    end

    test "update_com/2 with valid data updates the com" do
      com = com_fixture()
      update_attrs = %{deleted_at: ~N[2022-01-03 05:22:00], email: "some updated email", name: "some updated name", size: "some updated size", url: "some updated url"}

      assert {:ok, %Com{} = com} = Sup.update_com(com, update_attrs)
      assert com.deleted_at == ~N[2022-01-03 05:22:00]
      assert com.email == "some updated email"
      assert com.name == "some updated name"
      assert com.size == "some updated size"
      assert com.url == "some updated url"
    end

    test "update_com/2 with invalid data returns error changeset" do
      com = com_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_com(com, @invalid_attrs)
      assert com == Sup.get_com!(com.id)
    end

    test "delete_com/1 deletes the com" do
      com = com_fixture()
      assert {:ok, %Com{}} = Sup.delete_com(com)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_com!(com.id) end
    end

    test "change_com/1 returns a com changeset" do
      com = com_fixture()
      assert %Ecto.Changeset{} = Sup.change_com(com)
    end
  end

  describe "prods" do
    alias Lv13.Sup.Prod

    import Lv13.SupFixtures

    @invalid_attrs %{deleted_at: nil, name: nil, price: nil}

    test "list_prods/0 returns all prods" do
      prod = prod_fixture()
      assert Sup.list_prods() == [prod]
    end

    test "get_prod!/1 returns the prod with given id" do
      prod = prod_fixture()
      assert Sup.get_prod!(prod.id) == prod
    end

    test "create_prod/1 with valid data creates a prod" do
      valid_attrs = %{deleted_at: ~N[2022-01-02 05:32:00], name: "some name", price: 42}

      assert {:ok, %Prod{} = prod} = Sup.create_prod(valid_attrs)
      assert prod.deleted_at == ~N[2022-01-02 05:32:00]
      assert prod.name == "some name"
      assert prod.price == 42
    end

    test "create_prod/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_prod(@invalid_attrs)
    end

    test "update_prod/2 with valid data updates the prod" do
      prod = prod_fixture()
      update_attrs = %{deleted_at: ~N[2022-01-03 05:32:00], name: "some updated name", price: 43}

      assert {:ok, %Prod{} = prod} = Sup.update_prod(prod, update_attrs)
      assert prod.deleted_at == ~N[2022-01-03 05:32:00]
      assert prod.name == "some updated name"
      assert prod.price == 43
    end

    test "update_prod/2 with invalid data returns error changeset" do
      prod = prod_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_prod(prod, @invalid_attrs)
      assert prod == Sup.get_prod!(prod.id)
    end

    test "delete_prod/1 deletes the prod" do
      prod = prod_fixture()
      assert {:ok, %Prod{}} = Sup.delete_prod(prod)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_prod!(prod.id) end
    end

    test "change_prod/1 returns a prod changeset" do
      prod = prod_fixture()
      assert %Ecto.Changeset{} = Sup.change_prod(prod)
    end
  end

  describe "name" do
    alias Lv13.Sup.Task

    import Lv13.SupFixtures

    @invalid_attrs %{content: nil, deleted_at: nil, due_date: nil, person_in_charge: nil, priority: nil}

    test "list_name/0 returns all name" do
      task = task_fixture()
      assert Sup.list_name() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Sup.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{content: "some content", deleted_at: ~N[2022-01-02 05:34:00], due_date: ~N[2022-01-02 05:34:00], person_in_charge: "some person_in_charge", priority: "some priority"}

      assert {:ok, %Task{} = task} = Sup.create_task(valid_attrs)
      assert task.content == "some content"
      assert task.deleted_at == ~N[2022-01-02 05:34:00]
      assert task.due_date == ~N[2022-01-02 05:34:00]
      assert task.person_in_charge == "some person_in_charge"
      assert task.priority == "some priority"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{content: "some updated content", deleted_at: ~N[2022-01-03 05:34:00], due_date: ~N[2022-01-03 05:34:00], person_in_charge: "some updated person_in_charge", priority: "some updated priority"}

      assert {:ok, %Task{} = task} = Sup.update_task(task, update_attrs)
      assert task.content == "some updated content"
      assert task.deleted_at == ~N[2022-01-03 05:34:00]
      assert task.due_date == ~N[2022-01-03 05:34:00]
      assert task.person_in_charge == "some updated person_in_charge"
      assert task.priority == "some updated priority"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_task(task, @invalid_attrs)
      assert task == Sup.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Sup.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Sup.change_task(task)
    end
  end

  describe "cons" do
    alias Lv13.Sup.Con

    import Lv13.SupFixtures

    @invalid_attrs %{deleted_at: nil, email: nil, name: nil, position: nil}

    test "list_cons/0 returns all cons" do
      con = con_fixture()
      assert Sup.list_cons() == [con]
    end

    test "get_con!/1 returns the con with given id" do
      con = con_fixture()
      assert Sup.get_con!(con.id) == con
    end

    test "create_con/1 with valid data creates a con" do
      valid_attrs = %{deleted_at: ~N[2022-01-02 05:39:00], email: "some email", name: "some name", position: "some position"}

      assert {:ok, %Con{} = con} = Sup.create_con(valid_attrs)
      assert con.deleted_at == ~N[2022-01-02 05:39:00]
      assert con.email == "some email"
      assert con.name == "some name"
      assert con.position == "some position"
    end

    test "create_con/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_con(@invalid_attrs)
    end

    test "update_con/2 with valid data updates the con" do
      con = con_fixture()
      update_attrs = %{deleted_at: ~N[2022-01-03 05:39:00], email: "some updated email", name: "some updated name", position: "some updated position"}

      assert {:ok, %Con{} = con} = Sup.update_con(con, update_attrs)
      assert con.deleted_at == ~N[2022-01-03 05:39:00]
      assert con.email == "some updated email"
      assert con.name == "some updated name"
      assert con.position == "some updated position"
    end

    test "update_con/2 with invalid data returns error changeset" do
      con = con_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_con(con, @invalid_attrs)
      assert con == Sup.get_con!(con.id)
    end

    test "delete_con/1 deletes the con" do
      con = con_fixture()
      assert {:ok, %Con{}} = Sup.delete_con(con)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_con!(con.id) end
    end

    test "change_con/1 returns a con changeset" do
      con = con_fixture()
      assert %Ecto.Changeset{} = Sup.change_con(con)
    end
  end

  describe "appos" do
    alias Lv13.Sup.Appo

    import Lv13.SupFixtures

    @invalid_attrs %{amount: nil, date: nil, deleted_at: nil, description: nil, is_client: nil, name: nil, person_in_charge: nil, probability: nil, state: nil}

    test "list_appos/0 returns all appos" do
      appo = appo_fixture()
      assert Sup.list_appos() == [appo]
    end

    test "get_appo!/1 returns the appo with given id" do
      appo = appo_fixture()
      assert Sup.get_appo!(appo.id) == appo
    end

    test "create_appo/1 with valid data creates a appo" do
      valid_attrs = %{amount: 42, date: ~D[2022-01-02], deleted_at: ~N[2022-01-02 05:56:00], description: "some description", is_client: true, name: "some name", person_in_charge: "some person_in_charge", probability: 42, state: "some state"}

      assert {:ok, %Appo{} = appo} = Sup.create_appo(valid_attrs)
      assert appo.amount == 42
      assert appo.date == ~D[2022-01-02]
      assert appo.deleted_at == ~N[2022-01-02 05:56:00]
      assert appo.description == "some description"
      assert appo.is_client == true
      assert appo.name == "some name"
      assert appo.person_in_charge == "some person_in_charge"
      assert appo.probability == 42
      assert appo.state == "some state"
    end

    test "create_appo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_appo(@invalid_attrs)
    end

    test "update_appo/2 with valid data updates the appo" do
      appo = appo_fixture()
      update_attrs = %{amount: 43, date: ~D[2022-01-03], deleted_at: ~N[2022-01-03 05:56:00], description: "some updated description", is_client: false, name: "some updated name", person_in_charge: "some updated person_in_charge", probability: 43, state: "some updated state"}

      assert {:ok, %Appo{} = appo} = Sup.update_appo(appo, update_attrs)
      assert appo.amount == 43
      assert appo.date == ~D[2022-01-03]
      assert appo.deleted_at == ~N[2022-01-03 05:56:00]
      assert appo.description == "some updated description"
      assert appo.is_client == false
      assert appo.name == "some updated name"
      assert appo.person_in_charge == "some updated person_in_charge"
      assert appo.probability == 43
      assert appo.state == "some updated state"
    end

    test "update_appo/2 with invalid data returns error changeset" do
      appo = appo_fixture()
      assert {:error, %Ecto.Changeset{}} = Sup.update_appo(appo, @invalid_attrs)
      assert appo == Sup.get_appo!(appo.id)
    end

    test "delete_appo/1 deletes the appo" do
      appo = appo_fixture()
      assert {:ok, %Appo{}} = Sup.delete_appo(appo)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_appo!(appo.id) end
    end

    test "change_appo/1 returns a appo changeset" do
      appo = appo_fixture()
      assert %Ecto.Changeset{} = Sup.change_appo(appo)
    end
  end
end
