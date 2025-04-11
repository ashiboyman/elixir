defmodule TaskManager3Web.RaffleLiveTest do
  use TaskManager3Web.ConnCase

  import Phoenix.LiveViewTest
  import TaskManager3.RafflesFixtures

  @create_attrs %{status: :upcoming, description: "some description", prize: "some prize", ticket_price: 42, image_path: "some image_path"}
  @update_attrs %{status: :open, description: "some updated description", prize: "some updated prize", ticket_price: 43, image_path: "some updated image_path"}
  @invalid_attrs %{status: nil, description: nil, prize: nil, ticket_price: nil, image_path: nil}

  defp create_raffle(_) do
    raffle = raffle_fixture()
    %{raffle: raffle}
  end

  describe "Index" do
    setup [:create_raffle]

    test "lists all raffles", %{conn: conn, raffle: raffle} do
      {:ok, _index_live, html} = live(conn, ~p"/raffles")

      assert html =~ "Listing Raffles"
      assert html =~ raffle.description
    end

    test "saves new raffle", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/raffles")

      assert index_live |> element("a", "New Raffle") |> render_click() =~
               "New Raffle"

      assert_patch(index_live, ~p"/raffles/new")

      assert index_live
             |> form("#raffle-form", raffle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#raffle-form", raffle: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/raffles")

      html = render(index_live)
      assert html =~ "Raffle created successfully"
      assert html =~ "some description"
    end

    test "updates raffle in listing", %{conn: conn, raffle: raffle} do
      {:ok, index_live, _html} = live(conn, ~p"/raffles")

      assert index_live |> element("#raffles-#{raffle.id} a", "Edit") |> render_click() =~
               "Edit Raffle"

      assert_patch(index_live, ~p"/raffles/#{raffle}/edit")

      assert index_live
             |> form("#raffle-form", raffle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#raffle-form", raffle: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/raffles")

      html = render(index_live)
      assert html =~ "Raffle updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes raffle in listing", %{conn: conn, raffle: raffle} do
      {:ok, index_live, _html} = live(conn, ~p"/raffles")

      assert index_live |> element("#raffles-#{raffle.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#raffles-#{raffle.id}")
    end
  end

  describe "Show" do
    setup [:create_raffle]

    test "displays raffle", %{conn: conn, raffle: raffle} do
      {:ok, _show_live, html} = live(conn, ~p"/raffles/#{raffle}")

      assert html =~ "Show Raffle"
      assert html =~ raffle.description
    end

    test "updates raffle within modal", %{conn: conn, raffle: raffle} do
      {:ok, show_live, _html} = live(conn, ~p"/raffles/#{raffle}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Raffle"

      assert_patch(show_live, ~p"/raffles/#{raffle}/show/edit")

      assert show_live
             |> form("#raffle-form", raffle: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#raffle-form", raffle: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/raffles/#{raffle}")

      html = render(show_live)
      assert html =~ "Raffle updated successfully"
      assert html =~ "some updated description"
    end
  end
end
