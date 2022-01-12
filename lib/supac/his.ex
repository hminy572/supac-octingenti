defmodule Supac.His do
  @moduledoc """
  The His context.
  """

  import Ecto.Query, warn: false
  alias Supac.Repo

  alias Supac.His.Upd

  @doc """
  Returns the list of upds.

  ## Examples

      iex> list_upds()
      [%Upd{}, ...]

  """
  def list_upds do
    Repo.all(Upd)
  end

  # *************

  @doc """
  Full text search
  Returns list of leads based on from, to, and term
  To search full texts, result are encoded with Jason
  In order to do Jason.encode!(), change result into map and remove metadata key
  """
  def search_updates(from, to, term) do
    query = from u in Upd,
      where: u.inserted_at > ^from and u.inserted_at < ^to,
      limit: 100

    query
    |> Repo.all()
    |> Enum.filter(fn update ->
      update
      |> Map.from_struct()
      |> Map.delete(:__meta__)
      |> Jason.encode!()
      |> String.match?(~r/#{term}/)
      end)
  end

  @doc """
  Only search updated data
  Returns list of leads based on from, to, and term
  To search full texts, result are encoded with Jason
  In order to do Jason.encode!(), change result into map and remove metadata key
  """
  def search_only_updated(from, to, term) do
    query = from u in Upd,
      where: u.inserted_at > ^from and u.inserted_at < ^to,
      limit: 100

    query
    |> Repo.all()
    |> Enum.filter(fn update ->
      old_values =
        update
        |> SupacWeb.LiveHelpers.old_values()
        |> Enum.join()

      new_values =
        update
        |> SupacWeb.LiveHelpers.new_values()
        |> Enum.join()

      old_values <> new_values |> String.match?(~r/#{term}/)
      end)
  end

  # *************

  @doc """
  Gets a single upd.

  Raises `Ecto.NoResultsError` if the Upd does not exist.

  ## Examples

      iex> get_upd!(123)
      %Upd{}

      iex> get_upd!(456)
      ** (Ecto.NoResultsError)

  """
  def get_upd!(id), do: Repo.get!(Upd, id)

  @doc """
  Gets a latest update.

  Raises `Ecto.NoResultsError` if the Update does not exist.

  ## Examples

      iex> get_latest_update(123)
      %Update{}

      iex> get_latest_update(456)
      ** (Ecto.NoResultsError)

  """
  def get_latest_update() do
    query = from u in Upd, limit: 1, order_by: [desc: u.id]
    Repo.one(query)
  end
  @doc """
  Creates a upd.

  ## Examples

      iex> create_upd(%{field: value})
      {:ok, %Upd{}}

      iex> create_upd(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_upd(attrs \\ %{}) do
    %Upd{}
    |> Upd.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a upd.

  ## Examples

      iex> update_upd(upd, %{field: new_value})
      {:ok, %Upd{}}

      iex> update_upd(upd, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_upd(%Upd{} = upd, attrs) do
    upd
    |> Upd.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a upd.

  ## Examples

      iex> delete_upd(upd)
      {:ok, %Upd{}}

      iex> delete_upd(upd)
      {:error, %Ecto.Changeset{}}

  """
  def delete_upd(%Upd{} = upd) do
    Repo.delete(upd)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking upd changes.

  ## Examples

      iex> change_upd(upd)
      %Ecto.Changeset{data: %Upd{}}

  """
  def change_upd(%Upd{} = upd, attrs \\ %{}) do
    Upd.changeset(upd, attrs)
  end
end
