defmodule Lv13.SupTest do
  use Lv13.DataCase

  import Lv13.AccountsFixtures

  alias Lv13.Sup
  alias Lv13.Repo
  alias Lv13.Sup.Appo

  defp create_user(_) do
    user = confirmed_user_fixture()
    %{user: user}
  end

  describe "leads" do

    alias Lv13.Sup.Lead

    import Lv13.SupFixtures

    @invalid_attrs %{
      com_name: nil,
      email: nil,
      name: nil,
      position: Enum.random(Ecto.Enum.values(Lead, :position)),
      size: Enum.random(Ecto.Enum.values(Lead, :size)),
      state: Enum.random(Ecto.Enum.values(Lead, :state)),
      url: nil
    }

    test "list_leads/0 returns all leads" do
      lead = lead_fixture()
      assert Sup.list_leads() == [lead]
    end

    test "get_lead!/1 returns the lead with given id" do
      lead = lead_fixture()
      assert Sup.get_lead!(lead.id) == lead
    end

    test "create_lead/1 with valid data creates a lead" do
      valid_attrs = %{
        com_name: "some com_name",
        email: "some@email.com",
        name: "some name",
        position: Enum.random(Ecto.Enum.values(Lead, :position)),
        size: Enum.random(Ecto.Enum.values(Lead, :size)),
        state: Enum.random(Ecto.Enum.values(Lead, :state)),
        url: "https://some.url"
      }

      assert {:ok, %Lead{} = lead} = Sup.create_lead(valid_attrs)
      assert lead.com_name == "some com_name"
      assert lead.email == "some@email.com"
      assert lead.name == "some name"
      assert Enum.member?(Ecto.Enum.values(Lead, :position), lead.position)
      assert Enum.member?(Ecto.Enum.values(Lead, :size), lead.size)
      assert Enum.member?(Ecto.Enum.values(Lead, :state), lead.state)
      assert lead.url == "https://some.url"
    end

    test "create_lead/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_lead(@invalid_attrs)
    end

    test "update_lead/2 with valid data updates the lead" do
      lead = lead_fixture()
      update_attrs = %{
        com_name: "some updated com_name",
        email: "some@updated.email",
        name: "some updated name",
        position: Enum.random(Ecto.Enum.values(Lead, :position)),
        size: Enum.random(Ecto.Enum.values(Lead, :size)),
        state: Enum.random(Ecto.Enum.values(Lead, :state)),
        url: "https://some_updated.url"
      }

      assert {:ok, %Lead{} = lead} = Sup.update_lead(lead, update_attrs)
      assert lead.com_name == "some updated com_name"
      assert lead.email == "some@updated.email"
      assert lead.name == "some updated name"
      assert Enum.member?(Ecto.Enum.values(Lead, :position), lead.position)
      assert Enum.member?(Ecto.Enum.values(Lead, :size), lead.size)
      assert Enum.member?(Ecto.Enum.values(Lead, :state), lead.state)
      assert lead.url == "https://some_updated.url"
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

  describe "prods" do
    alias Lv13.Sup.Prod

    import Lv13.SupFixtures

    @invalid_attrs %{name: nil, price: nil}

    test "list_prods/0 returns all prods" do
      prod = prod_fixture()
      assert Sup.list_prods() |> Repo.preload(:appos) == [prod]
    end

    test "get_prod!/1 returns the prod with given id" do
      prod = prod_fixture()
      assert Sup.get_prod!(prod.id) == prod
    end

    test "create_prod/1 with valid data creates a prod" do
      valid_attrs = %{name: "some name", price: 42}

      assert {:ok, %Prod{} = prod} = Sup.create_prod(valid_attrs)
      assert prod.name == "some name"
      assert prod.price == 42
    end

    test "create_prod/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_prod(@invalid_attrs)
    end

    test "update_prod/2 with valid data updates the prod" do
      prod = prod_fixture()
      update_attrs = %{name: "some updated name", price: 43}

      assert {:ok, %Prod{} = prod} = Sup.update_prod(prod, update_attrs)
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

  describe "tasks" do
    alias Lv13.Sup.Task

    import Lv13.SupFixtures

    @invalid_attrs %{
      content: nil,
      due_date: nil,
      name: nil,
      person_in_charge: nil,
      priority: Enum.random(Ecto.Enum.values(Task, :priority))
    }

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Sup.list_tasks() |> Repo.preload(:com) == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Sup.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{
        content: "some content",
        due_date: ~D[2021-12-11],
        name: "some name",
        person_in_charge: "some person_in_charge",
        priority: Enum.random(Ecto.Enum.values(Task, :priority))
      }

      assert {:ok, %Task{} = task} = Sup.create_task(valid_attrs)
      assert task.content == "some content"
      assert task.due_date == ~D[2021-12-11]
      assert task.name == "some name"
      assert task.person_in_charge == "some person_in_charge"
      assert Enum.member?(Ecto.Enum.values(Task, :priority), task.priority)
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{
        content: "some updated content",
        due_date: ~D[2021-12-12],
        name: "some updated name",
        person_in_charge: "some updated person_in_charge",
        priority: Enum.random(Ecto.Enum.values(Task, :priority))
      }

      assert {:ok, %Task{} = task} = Sup.update_task(task, update_attrs)
      assert task.content == "some updated content"
      assert task.due_date == ~D[2021-12-12]
      assert task.name == "some updated name"
      assert task.person_in_charge == "some updated person_in_charge"
      assert Enum.member?(Ecto.Enum.values(Task, :priority), task.priority)
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

    @invalid_attrs %{
      email: nil,
      name: nil,
      position: Enum.random(Ecto.Enum.values(Con, :position))
    }

    test "list_cons/0 returns all cons" do
      con = con_fixture()
      assert Sup.list_cons() |> Repo.preload(:com) == [con]
    end

    test "get_con!/1 returns the con with given id" do
      con = con_fixture()
      assert Sup.get_con!(con.id) == con
    end

    test "create_con/1 with valid data creates a con" do
      valid_attrs = %{
        email: "some@email.com",
        name: "some name",
        position: Enum.random(Ecto.Enum.values(Con, :position))
      }

      assert {:ok, %Con{} = con} = Sup.create_con(valid_attrs)
      assert con.email == "some@email.com"
      assert con.name == "some name"
      assert Enum.member?(Ecto.Enum.values(Con, :position), con.position)
    end

    test "create_con/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_con(@invalid_attrs)
    end

    test "update_con/2 with valid data updates the con" do
      con = con_fixture()
      update_attrs = %{
        email: "some@updated.email",
        name: "some updated name",
        position: Enum.random(Ecto.Enum.values(Con, :position))
      }

      assert {:ok, %Con{} = con} = Sup.update_con(con, update_attrs)
      assert con.email == "some@updated.email"
      assert con.name == "some updated name"
      assert Enum.member?(Ecto.Enum.values(Con, :position), con.position)
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

  defp create_appo(user) do
    {:ok, appo} =
      %{}
      |> Enum.into(%{
        amount: :rand.uniform(10) * 1000,
        date: Faker.Date.backward(10),
        description: Faker.Lorem.paragraph,
        is_client: true,
        name: Faker.Pokemon.name,
        probability: :rand.uniform(),
        person_in_charge: user.name,
        state: Enum.random(Ecto.Enum.values(Appo, :state)),
      })
      |> Lv13.Sup.create_appo()

    Repo.preload(appo, [:com, :prod])
  end

  describe "appos" do
    setup [:create_user]

    alias Lv13.Sup.Appo

    import Lv13.SupFixtures

    @invalid_attrs %{
      amount: nil,
      date: nil,
      description: nil,
      is_client: nil,
      name: nil,
      person_in_charge: nil,
      probability: nil,
      state: :Prospecting
    }

    test "list_appos/0 returns all appos", %{user: user} do
      appo = create_appo(user)
      assert Sup.list_appos() |> Repo.preload([:com, :prod]) == [appo]
    end

    test "get_appo!/1 returns the appo with given id", %{user: user} do
      appo = create_appo(user)
      assert Sup.get_appo!(appo.id) == appo
    end

    test "create_appo/1 with valid data creates a appo", %{user: user} do
      valid_attrs = %{
        amount: 42,
        date: ~D[2021-12-11],
        description: "some description",
        is_client: true,
        name: "some name",
        person_in_charge: user.name,
        probability: 120.5,
        state: Enum.random(Ecto.Enum.values(Appo, :state)),
      }

      assert {:ok, %Appo{} = appo} = Sup.create_appo(valid_attrs)
      assert appo.amount == 42
      assert appo.date == ~D[2021-12-11]
      assert appo.description == "some description"
      assert appo.is_client == true
      assert appo.name == "some name"
      assert appo.person_in_charge == user.name
      assert appo.probability == 120.5
      assert Enum.member?(Ecto.Enum.values(Appo, :state), appo.state)
    end

    test "create_appo/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Sup.create_appo(Map.merge(@invalid_attrs, %{person_in_charge: user.name}))
    end

    test "update_appo/2 with valid data updates the appo", %{user: user} do
      appo = create_appo(user)
      update_attrs = %{
        amount: 43,
        date: ~D[2021-12-12],
        description: "some updated description",
        is_client: false,
        name: "some updated name",
        person_in_charge: user.name,
        probability: 456.7,
        state: Enum.random(Ecto.Enum.values(Appo, :state))
      }

      assert {:ok, %Appo{} = appo} = Sup.update_appo(appo, update_attrs)
      assert appo.amount == 43
      assert appo.date == ~D[2021-12-12]
      assert appo.description == "some updated description"
      assert appo.is_client == false
      assert appo.name == "some updated name"
      assert appo.person_in_charge == user.name
      assert appo.probability == 456.7
      assert Enum.member?(Ecto.Enum.values(Appo, :state), appo.state)
    end

    test "update_appo/2 with invalid data returns error changeset", %{user: user} do
      appo = create_appo(user)
      assert {:error, %Ecto.Changeset{}} = Sup.update_appo(appo, Map.merge(@invalid_attrs, %{person_in_charge: user.name}))
      assert appo == Sup.get_appo!(appo.id)
    end

    test "delete_appo/1 deletes the appo", %{user: user} do
      appo = create_appo(user)
      assert {:ok, %Appo{}} = Sup.delete_appo(appo)
      assert_raise Ecto.NoResultsError, fn -> Sup.get_appo!(appo.id) end
    end

    test "change_appo/1 returns a appo changeset", %{user: user} do
      appo = create_appo(user)
      assert %Ecto.Changeset{} = Sup.change_appo(appo)
    end
  end

  describe "coms" do
    alias Lv13.Sup.Com

    import Lv13.SupFixtures

    @invalid_attrs %{
      email: nil,
      name: nil,
      size: Enum.random(Ecto.Enum.values(Com, :size)),
      url: nil
    }

    test "list_coms/0 returns all coms" do
      com = com_fixture()
      assert Sup.list_coms() |> Repo.preload([:cons, :appos, :tasks]) == [com]
    end

    test "get_com!/1 returns the com with given id" do
      com = com_fixture()
      assert Sup.get_com!(com.id) == com
    end

    test "create_com/1 with valid data creates a com" do
      valid_attrs = %{
        email: "some@email.com",
        name: "some name",
        size: Enum.random(Ecto.Enum.values(Com, :size)),
        url: "http://some.url"
      }

      assert {:ok, %Com{} = com} = Sup.create_com(valid_attrs)
      assert com.email == "some@email.com"
      assert com.name == "some name"
      assert Enum.member?(Ecto.Enum.values(Com, :size), com.size)
      assert com.url == "http://some.url"
    end

    test "create_com/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sup.create_com(@invalid_attrs)
    end

    test "update_com/2 with valid data updates the com" do
      com = com_fixture()
      update_attrs = %{
        email: "some@updated.email",
        name: "some updated name",
        size: Enum.random(Ecto.Enum.values(Com, :size)),
        url: "http://some_updated.url"
      }

      assert {:ok, %Com{} = com} = Sup.update_com(com, update_attrs)
      assert com.email == "some@updated.email"
      assert com.name == "some updated name"
      assert Enum.member?(Ecto.Enum.values(Com, :size), com.size)
      assert com.url == "http://some_updated.url"
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
end
