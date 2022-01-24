defmodule Supac.Sup do
  @moduledoc """
  The Sup context.
  """

  import Ecto.Query, warn: false
  alias Supac.Repo
  alias Supac.Sup.{
    Lead,
    Prod,
    Task,
    Con,
    Com,
    Appo
  }

  @doc """
  Search and return entries related to the given term
  """
  def search(term) do
    term = "%#{term}%"

    appo = from a in Appo,
      where: ilike(a.name, ^term) or
        ilike(a.state, ^term) or
        ilike(a.description, ^term) or
        ilike(a.person_in_charge, ^term),
      limit: 10

    com = from c in Com,
      where: ilike(c.name, ^term) or
        ilike(c.size, ^term) or
        ilike(c.email, ^term),
      limit: 10

    con = from c in Con,
      where: ilike(c.name, ^term) or
        ilike(c.position, ^term) or
        ilike(c.email, ^term),
      limit: 10

    lead = from l in Lead,
      where: ilike(l.name, ^term) or
        ilike(l.com_name, ^term) or
        ilike(l.state, ^term) or
        ilike(l.email, ^term),
      limit: 10

    prod = from p in Prod,
      where: ilike(p.name, ^term),
      limit: 10

    task = from t in Task,
      where: ilike(t.name, ^term) or
        ilike(t.person_in_charge, ^term) or
        ilike(t.content, ^term),
      limit: 10

    %{
      appos: Repo.all(exclude_removed_records(appo)),
      coms: Repo.all(exclude_removed_records(com)),
      cons: Repo.all(exclude_removed_records(con)),
      leads: Repo.all(exclude_removed_records(lead)),
      prods: Repo.all(exclude_removed_records(prod)),
      tasks: Repo.all(exclude_removed_records(task))
    }
  end

  defp exclude_removed_records(query) do
    from q in query, where: is_nil(q.deleted_at), order_by: [desc: q.updated_at]
  end

  @doc """
  Returns the list of leads.

  ## Examples

      iex> list_leads()
      [%Lead{}, ...]

  """
  def list_leads do
    query = from l in Lead, where: is_nil(l.deleted_at), limit: 30, order_by: [desc: l.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the data list for dataset of Pie Chart about leads.

  """
  def pie_chart_leads() do
    query = from l in Lead, where: is_nil(l.deleted_at), select: l.state
    res =
      Repo.all(query)
      |> Enum.frequencies() # %{日程調整中: 21, 案件化: 15, 見込み: 13, 連絡済み: 11}
      |> Enum.map(fn {_, num} -> num end) # [21, 15, 13, 11]
    sum = Enum.sum(res)
    Enum.map(res, fn x -> Kernel./(x, sum) end) # final_result [0.35, 0.25, 0.21666666666666667, 0.18333333333333332]
  end

  @doc """
  Returns the data list for dataset of Bar Chart about leads.

  """
  def bar_chart_leads() do
    query = from l in Lead, where: is_nil(l.deleted_at), select: l.size
    Repo.all(query)
    # |> Enum.frequencies()
    # |> Map.to_list()
    # |> Enum.map(fn {x, y} -> {Atom.to_string(x), y} end)
  end

  @doc """
  Returns the data list for dataset of  Chart about leads.

  To make the data 30 days list,
  add 29 additional date data before Enum.frequencies
  and subtract 1 from frequency values afterwards in ordr to remove additional date data.
  """
  def line_path_leads() do
    query = from l in Lead, where: is_nil(l.deleted_at), select: l.inserted_at
    date_list = Repo.all(query)
    first =
      if date_list == [] do
        NaiveDateTime.utc_now()
      else
        Enum.at(date_list, 0)
      end

    date_list ++ Enum.map(1..29, &([] ++ NaiveDateTime.add(first, 86_400 * &1) )) # [~N[2021-12-11 13:54:29], ~N[2021-12-12 13:54:29], .. ~N[2022-01-09 13:54:29]]
    |> Enum.map(fn x -> NaiveDateTime.to_date(x) end )
    |> Enum.frequencies() # %{~N[2021-12-11] => 1, ~N[2021-12-12] => 1, .. ~N[2021-01-09] => 1}
    |> Map.to_list() # [{~N[2021-12-11], 1}, {~N[2021-12-12], 1}, .. {~N[2021-01-09], 1}]
    |> Enum.map(fn {x, y} ->
        {:ok, ndt} = NaiveDateTime.new(x, ~T[00:00:00])
        [ndt, y - 1]
      end )
    |> Enum.map(fn [ndt, num] -> [ndt.day * 30 - 30, 495 - num * 3] end)
    |> Enum.map(fn [x, y] -> [Integer.to_string(x), Integer.to_string(y)] end)
    |> Enum.map(fn [x, y] -> "#{x} #{y} L #{x} #{y} " end)
    |> List.to_string()
  end

  @doc """
  Returns the data list for dataset of  Chart about leads.

  To make the data 30 days list,
  add 29 additional date data before Enum.frequencies
  and subtract 1 from frequency values afterwards in ordr to remove additional date data.
  """
  def line_circle_leads() do
    query = from l in Lead, where: is_nil(l.deleted_at), select: l.inserted_at
    date_list = Repo.all(query)
    first =
      if date_list == [] do
        NaiveDateTime.utc_now()
      else
        Enum.at(date_list, 0)
      end

    date_list ++ Enum.map(1..29, &([] ++ NaiveDateTime.add(first, 86_400 * &1) )) # [~N[2021-12-11 13:54:29], ~N[2021-12-12 13:54:29], .. ~N[2022-01-09 13:54:29]]
    |> Enum.map(fn x -> NaiveDateTime.to_date(x) end )
    |> Enum.frequencies() # %{~N[2021-12-11] => 1, ~N[2021-12-12] => 1, .. ~N[2021-01-09] => 1}
    |> Map.to_list() # [{~N[2021-12-11], 1}, {~N[2021-12-12], 1}, .. {~N[2021-01-09], 1}]
    |> Enum.map(fn {x, y} ->
        {:ok, ndt} = NaiveDateTime.new(x, ~T[00:00:00])
        [ndt, y - 1]
      end )
    |> Enum.map(fn [ndt, num] -> [ndt.day * 30 - 30, 495 - num * 3] end)
    |> Enum.map(fn [x, y] -> [Integer.to_string(x), Integer.to_string(y)] end)
  end

  @doc """
  Returns the list of leads include given term in name.

  ## Examples

      iex> search_leads("a")
      [%Lead{}, ...]

  """
  def search_leads(term) do
    term = "%#{term}%"
    query = from l in Lead,
      where: ilike(l.name, ^term) or
        ilike(l.com_name, ^term) or
        ilike(l.state, ^term) or
        ilike(l.email, ^term),
      limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single lead.

  Raises `Ecto.NoResultsError` if the Lead does not exist.

  ## Examples

      iex> get_lead!(1)
      %Lead{}

      iex> get_lead!(9999)
      ** (Ecto.NoResultsError)

  """
  def get_lead!(id) do
    query = from l in Lead, where: is_nil(l.deleted_at)
    Repo.get!(query, id)
  end

  @doc """
  Gets a single lead.

  Raises `Ecto.NoResultsError` if the Lead does not exist.

  ## Examples

      iex> get_lead!(1)
      %Lead{}

      iex> get_lead!(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_lead() do
    query = from l in Lead, limit: 1, order_by: [desc: l.updated_at]
    Repo.one(query)
  end
  @doc """
  Creates a lead.

  ## Examples

      iex> create_lead(%{field: value})
      {:ok, %Lead{}}

      iex> create_lead(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lead(attrs \\ %{}) do
    %Lead{}
    |> Lead.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lead.

  ## Examples

      iex> update_lead(lead, %{field: new_value})
      {:ok, %Lead{}}

      iex> update_lead(lead, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lead(%Lead{} = lead, attrs) do
    lead
    |> Lead.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a lead.

  ## Examples

      iex> delete_lead(lead)
      {:ok, %Lead{}}

      iex> delete_lead(lead)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lead(%Lead{} = lead) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    lead
    |> Lead.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lead changes.

  ## Examples

      iex> change_lead(lead)
      %Ecto.Changeset{data: %Lead{}}

  """
  def change_lead(%Lead{} = lead, attrs \\ %{}) do
    Lead.changeset(lead, attrs)
  end

  @doc """
  Returns the list of prods.

  ## Examples

      iex> list_prods()
      [%Prod{}, ...]

  """
  def list_prods do
    query = from p in Prod, where: is_nil(p.deleted_at), limit: 30, order_by: [desc: p.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of prods include given term in name.

  ## Examples

      iex> search_prods()
      [%Prod{}, ...]

  """
  def search_prods(term) do
    term = "%#{term}%"
    query = from p in Prod, where: ilike(p.name, ^term), limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single prod.

  Raises `Ecto.NoResultsError` if the prod does not exist.

  ## Examples

      iex> get_prod!(123)
      %Prod{}

      iex> get_prod!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prod!(id) do
    query = from p in Prod, where: is_nil(p.deleted_at)
    Repo.get!(query, id)|> Repo.preload([:appos])
  end

  @doc """
  Gets a recent updated prod.

  Raises `Ecto.NoResultsError` if the prod does not exist.

  ## Examples

      iex> recent_updated_prod(1)
      %Prod{}

      iex> recent_updated_prod(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_prod() do
    query = from p in Prod, limit: 1, order_by: [desc: p.updated_at]
    Repo.one(query)
  end

  @doc """
  Creates a prod.

  ## Examples

      iex> create_prod(%{field: value})
      {:ok, %Prod{}}

      iex> create_prod(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prod(attrs \\ %{}) do
    %Prod{}
    |> Prod.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a prod.

  ## Examples

      iex> update_prod(prod, %{field: new_value})
      {:ok, %Prod{}}

      iex> update_prod(prod, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prod(%Prod{} = prod, attrs) do
    prod
    |> Prod.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a prod.

  ## Examples

      iex> delete_prod(prod)
      {:ok, %Prod{}}

      iex> delete_prod(prod)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prod(%Prod{} = prod) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    prod
    |> Prod.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prod changes.

  ## Examples

      iex> change_prod(prod)
      %Ecto.Changeset{data: %Prod{}}

  """
  def change_prod(%Prod{} = prod, attrs \\ %{}) do
    Prod.changeset(prod, attrs)
  end


  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    query = from t in Task, where: is_nil(t.deleted_at), limit: 30, order_by: [desc: t.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of tasks include given term in name.

  ## Examples

      iex> search_tasks()
      [%Task{}, ...]

  """
  def search_tasks(term) do
    term = "%#{term}%"
    query = from t in Task,
      where: ilike(t.name, ^term) or
        ilike(t.person_in_charge, ^term) or
        ilike(t.content, ^term),
      limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    query = from t in Task, where: is_nil(t.deleted_at)
    Repo.get!(query, id) |> Repo.preload([:com])
  end

  @doc """
  Gets a recent updated task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> recent_updated_task(1)
      %Task{}

      iex> recent_updated_task(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_task() do
    query = from t in Task, limit: 1, order_by: [desc: t.updated_at]
    Repo.one(query)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    task
    |> Task.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end


  @doc """
  Returns the list of cons.

  ## Examples

      iex> list_cons()
      [%Con{}, ...]

  """
  def list_cons do
    query = from c in Con, where: is_nil(c.deleted_at), limit: 30, order_by: [desc: c.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of cons include given term in name.

  ## Examples

      iex> search_cons()
      [%Con{}, ...]

  """
  def search_cons(term) do
    term = "%#{term}%"
    query = from c in Con,
      where: ilike(c.name, ^term) or
        ilike(c.email, ^term) or
        ilike(c.position, ^term),
      limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single con.

  Raises `Ecto.NoResultsError` if the Con does not exist.

  ## Examples

      iex> get_con!(123)
      %Con{}

      iex> get_con!(456)
      ** (Ecto.NoResultsError)

  """
  def get_con!(id) do
    query = from c in Con, where: is_nil(c.deleted_at)
    Repo.get!(query, id) |> Repo.preload([:com])
  end

  @doc """
  Gets a recent updated con.

  Raises `Ecto.NoResultsError` if the Con does not exist.

  ## Examples

      iex> recent_updated_con(1)
      %Con{}

      iex> recent_updated_con(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_con() do
    query = from c in Con, limit: 1, order_by: [desc: c.updated_at]
    Repo.one(query)
  end

  @doc """
  Creates a con.

  ## Examples

      iex> create_con(%{field: value})
      {:ok, %Con{}}

      iex> create_con(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_con(attrs \\ %{}) do
    %Con{}
    |> Con.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a con.

  ## Examples

      iex> update_con(con, %{field: new_value})
      {:ok, %Con{}}

      iex> update_con(con, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_con(%Con{} = con, attrs) do
    con
    |> Con.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a con.

  ## Examples

      iex> delete_con(con)
      {:ok, %Con{}}

      iex> delete_con(con)
      {:error, %Ecto.Changeset{}}

  """
  def delete_con(%Con{} = con) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    con
    |> Con.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking con changes.

  ## Examples

      iex> change_con(con)
      %Ecto.Changeset{data: %Con{}}

  """
  def change_con(%Con{} = con, attrs \\ %{}) do
    Con.changeset(con, attrs)
  end


  @doc """
  Returns the list of appos.

  ## Examples

      iex> list_appos()
      [%Appo{}, ...]

  """
  def list_appos do
    query = from a in Appo, where: is_nil(a.deleted_at), limit: 30, order_by: [desc: a.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of appos include given term in name.

  ## Examples

      iex> search_appos()
      [%Appo{}, ...]

  """
  def search_appos(term) do
    term = "%#{term}%"
    query = from a in Appo,
      where: ilike(a.name, ^term) or
        ilike(a.state, ^term) or
        ilike(a.description, ^term) or
        ilike(a.person_in_charge, ^term),
      limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single appo.

  Raises `Ecto.NoResultsError` if the Appo does not exist.

  ## Examples

      iex> get_appo!(123)
      %Appo{}

      iex> get_appo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_appo!(id) do
    query = from a in Appo, where: is_nil(a.deleted_at)
    Repo.get!(query, id) |> Repo.preload([:com, :prod])
  end

  @doc """
  Gets a single appo.

  Raises `Ecto.NoResultsError` if the Appo does not exist.

  ## Examples

      iex> get_latest_appo(123)
      %Appo{}

      iex> get_latest_appo(456)
      ** (Ecto.NoResultsError)

  """
  def get_latest_appo() do
    query = from a in Appo, where: is_nil(a.deleted_at), limit: 1, order_by: [desc: a.id]
    Repo.one(query) |> Repo.preload([:com, :prod])
  end

  @doc """
  Gets a recent updated appo.

  Raises `Ecto.NoResultsError` if the Appo does not exist.

  ## Examples

      iex> recent_updated_appo(1)
      %Appo{}

      iex> recent_updated_appo(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_appo() do
    query = from a in Appo, limit: 1, order_by: [desc: a.updated_at]
    Repo.one(query)
  end

  @doc """
  Creates a appo.

  ## Examples

      iex> create_appo(%{field: value})
      {:ok, %Appo{}}

      iex> create_appo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_appo(attrs \\ %{}) do
    %Appo{}
    |> Appo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a appo.

  ## Examples

      iex> update_appo(appo, %{field: new_value})
      {:ok, %Appo{}}

      iex> update_appo(appo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_appo(%Appo{} = appo, attrs) do
    appo
    |> Appo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a appo.

  ## Examples

      iex> delete_appo(appo)
      {:ok, %Appo{}}

      iex> delete_appo(appo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_appo(%Appo{} = appo) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    appo
    |> Appo.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking appo changes.

  ## Examples

      iex> change_appo(appo)
      %Ecto.Changeset{data: %Appo{}}

  """
  def change_appo(%Appo{} = appo, attrs \\ %{}) do
    Appo.changeset(appo, attrs)
  end


  @doc """
  Returns the list of coms.

  ## Examples

      iex> list_coms()
      [%Com{}, ...]

  """
  def list_coms do
    query = from c in Com, where: is_nil(c.deleted_at), limit: 30, order_by: [desc: c.updated_at]
    Repo.all(query)
  end

  @doc """
  Returns the list of coms include given term in name.

  ## Examples

      iex> search_coms()
      [%Com{}, ...]

  """
  def search_coms(term) do
    term = "%#{term}%"
    query = from c in Com,
      where: ilike(c.name, ^term) or
        ilike(c.email, ^term) or
        ilike(c.url, ^term),
      limit: 30
    Repo.all(exclude_removed_records(query))
  end

  @doc """
  Gets a single com.

  Raises `Ecto.NoResultsError` if the Com does not exist.

  ## Examples

      iex> get_com!(123)
      %Com{}

      iex> get_com!(456)
      ** (Ecto.NoResultsError)

  """
  def get_com!(id) do
    query = from c in Com, where: is_nil(c.deleted_at)
    Repo.get!(query, id) |> Repo.preload([:cons, :appos, :tasks])
  end

  @doc """
  Gets a recent updated com.

  Raises `Ecto.NoResultsError` if the Com does not exist.

  ## Examples

      iex> recent_updated_com(1)
      %Com{}

      iex> recent_updated_com(9999)
      ** (Ecto.NoResultsError)

  """
  def recent_updated_com() do
    query = from c in Com, limit: 1, order_by: [desc: c.updated_at]
    Repo.one(query)
  end
  @doc """
  Creates a com.

  ## Examples

      iex> create_com(%{field: value})
      {:ok, %Com{}}

      iex> create_com(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_com(attrs \\ %{}) do
    %Com{}
    |> Com.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a com.

  ## Examples

      iex> update_com(com, %{field: new_value})
      {:ok, %Com{}}

      iex> update_com(com, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_com(%Com{} = com, attrs) do
    com
    |> Com.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a com.

  ## Examples

      iex> delete_com(com)
      {:ok, %Com{}}

      iex> delete_com(com)
      {:error, %Ecto.Changeset{}}

  """
  def delete_com(%Com{} = com) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    com
    |> Com.delete_changeset(%{deleted_at: now})
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking com changes.

  ## Examples

      iex> change_com(com)
      %Ecto.Changeset{data: %Com{}}

  """
  def change_com(%Com{} = com, attrs \\ %{}) do
    Com.changeset(com, attrs)
  end
end
