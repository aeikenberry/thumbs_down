defmodule ThumbsDownWeb.GameControllerTest do
  use ThumbsDownWeb.ConnCase

  alias ThumbsDown.Games

  @create_attrs %{duration: 120.5, end_time: ~N[2010-04-17 14:00:00.000000], room_id: "some room_id", start_time: ~N[2010-04-17 14:00:00.000000]}
  @update_attrs %{duration: 456.7, end_time: ~N[2011-05-18 15:01:01.000000], room_id: "some updated room_id", start_time: ~N[2011-05-18 15:01:01.000000]}
  @invalid_attrs %{duration: nil, end_time: nil, room_id: nil, start_time: nil}

  def fixture(:game) do
    {:ok, game} = Games.create_game(@create_attrs)
    game
  end

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get conn, game_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "new game" do
    test "renders form", %{conn: conn} do
      conn = get conn, game_path(conn, :new)
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "create game" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == game_path(conn, :show, id)

      conn = get conn, game_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Game"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, game_path(conn, :create), game: @invalid_attrs
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "edit game" do
    setup [:create_game]

    test "renders form for editing chosen game", %{conn: conn, game: game} do
      conn = get conn, game_path(conn, :edit, game)
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "update game" do
    setup [:create_game]

    test "redirects when data is valid", %{conn: conn, game: game} do
      conn = put conn, game_path(conn, :update, game), game: @update_attrs
      assert redirected_to(conn) == game_path(conn, :show, game)

      conn = get conn, game_path(conn, :show, game)
      assert html_response(conn, 200) =~ "some updated room_id"
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put conn, game_path(conn, :update, game), game: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete conn, game_path(conn, :delete, game)
      assert redirected_to(conn) == game_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, game_path(conn, :show, game)
      end
    end
  end

  defp create_game(_) do
    game = fixture(:game)
    {:ok, game: game}
  end
end
