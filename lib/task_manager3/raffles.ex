defmodule TaskManager3.Raffles do
  @moduledoc """
  The Raffles context.
  """

  import Ecto.Query, warn: false
  alias TaskManager3.Repo

  alias TaskManager3.Raffles.Raffle

  @doc """
  Returns the list of raffles.

  ## Examples

      iex> list_raffles()
      [%Raffle{}, ...]

  """
  def list_raffles do
    Repo.all(Raffle)
  end

  def filter_raffles(filter) do
    # Process.sleep(1000)

    Raffle
    |> with_status(filter["status"])
    |> search_by(filter["q"])
    |> Repo.all()
  end

  defp with_status(query, status)
       when status in ~w(open closed upcoming) do
    where(query, status: ^status)
  end

  defp with_status(query, _), do: query

  defp search_by(query, q) when q in ["", nil], do: query

  defp search_by(query, q) do
    where(query, [r], ilike(r.prize, ^"%#{q}%"))
  end

  @doc """
  Gets a single raffle.

  Raises `Ecto.NoResultsError` if the Raffle does not exist.

  ## Examples

      iex> get_raffle!(123)
      %Raffle{}

      iex> get_raffle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_raffle!(id) do
    Process.sleep(5000)
    # raise("fuck")
    Repo.get!(Raffle, id)
  end

  @doc """
  Creates a raffle.

  ## Examples

      iex> create_raffle(%{field: value})
      {:ok, %Raffle{}}

      iex> create_raffle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_raffle(attrs \\ %{}) do
    %Raffle{}
    |> Raffle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a raffle.

  ## Examples

      iex> update_raffle(raffle, %{field: new_value})
      {:ok, %Raffle{}}

      iex> update_raffle(raffle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_raffle(%Raffle{} = raffle, attrs) do
    raffle
    |> Raffle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a raffle.

  ## Examples

      iex> delete_raffle(raffle)
      {:ok, %Raffle{}}

      iex> delete_raffle(raffle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_raffle(%Raffle{} = raffle) do
    Repo.delete(raffle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking raffle changes.

  ## Examples

      iex> change_raffle(raffle)
      %Ecto.Changeset{data: %Raffle{}}

  """
  def change_raffle(%Raffle{} = raffle, attrs \\ %{}) do
    Raffle.changeset(raffle, attrs)
  end
end
