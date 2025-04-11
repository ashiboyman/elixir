defmodule TaskManager3.RafflesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskManager3.Raffles` context.
  """

  @doc """
  Generate a raffle.
  """
  def raffle_fixture(attrs \\ %{}) do
    {:ok, raffle} =
      attrs
      |> Enum.into(%{
        description: "some description",
        image_path: "some image_path",
        prize: "some prize",
        status: :upcoming,
        ticket_price: 42
      })
      |> TaskManager3.Raffles.create_raffle()

    raffle
  end
end
