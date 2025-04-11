defmodule TaskManager3.RafflesTest do
  use TaskManager3.DataCase

  alias TaskManager3.Raffles

  describe "raffles" do
    alias TaskManager3.Raffles.Raffle

    import TaskManager3.RafflesFixtures

    @invalid_attrs %{status: nil, description: nil, prize: nil, ticket_price: nil, image_path: nil}

    test "list_raffles/0 returns all raffles" do
      raffle = raffle_fixture()
      assert Raffles.list_raffles() == [raffle]
    end

    test "get_raffle!/1 returns the raffle with given id" do
      raffle = raffle_fixture()
      assert Raffles.get_raffle!(raffle.id) == raffle
    end

    test "create_raffle/1 with valid data creates a raffle" do
      valid_attrs = %{status: :upcoming, description: "some description", prize: "some prize", ticket_price: 42, image_path: "some image_path"}

      assert {:ok, %Raffle{} = raffle} = Raffles.create_raffle(valid_attrs)
      assert raffle.status == :upcoming
      assert raffle.description == "some description"
      assert raffle.prize == "some prize"
      assert raffle.ticket_price == 42
      assert raffle.image_path == "some image_path"
    end

    test "create_raffle/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Raffles.create_raffle(@invalid_attrs)
    end

    test "update_raffle/2 with valid data updates the raffle" do
      raffle = raffle_fixture()
      update_attrs = %{status: :open, description: "some updated description", prize: "some updated prize", ticket_price: 43, image_path: "some updated image_path"}

      assert {:ok, %Raffle{} = raffle} = Raffles.update_raffle(raffle, update_attrs)
      assert raffle.status == :open
      assert raffle.description == "some updated description"
      assert raffle.prize == "some updated prize"
      assert raffle.ticket_price == 43
      assert raffle.image_path == "some updated image_path"
    end

    test "update_raffle/2 with invalid data returns error changeset" do
      raffle = raffle_fixture()
      assert {:error, %Ecto.Changeset{}} = Raffles.update_raffle(raffle, @invalid_attrs)
      assert raffle == Raffles.get_raffle!(raffle.id)
    end

    test "delete_raffle/1 deletes the raffle" do
      raffle = raffle_fixture()
      assert {:ok, %Raffle{}} = Raffles.delete_raffle(raffle)
      assert_raise Ecto.NoResultsError, fn -> Raffles.get_raffle!(raffle.id) end
    end

    test "change_raffle/1 returns a raffle changeset" do
      raffle = raffle_fixture()
      assert %Ecto.Changeset{} = Raffles.change_raffle(raffle)
    end
  end
end
