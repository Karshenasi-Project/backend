defmodule BackendWeb.UserControllerTest do
  use BackendWeb.ConnCase

  import Backend.AccountsFixtures

  alias Backend.Accounts.User

  @create_attrs %{
    balance: 120.5,
    code: "some code",
    phone_number: "some phone_number",
    pub_key: "some pub_key",
    is_admin: false
  }
  @update_attrs %{
    balance: 456.7,
    code: "some updated code",
    phone_number: "some updated phone_number",
    pub_key: "some updated pub_key",
    is_admin: false

  }

  @invalid_attrs %{balance: nil, code: nil, phone_number: nil, pub_key: nil, is_admin: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end


  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 120.5,
               "code" => "some code",
               "phone_number" => "some phone_number",
               "pub_key" => "some pub_key",
               "is_admin" => false
               } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "balance" => 456.7,
               "code" => "some updated code",
               "phone_number" => "some updated phone_number",
               "pub_key" => "some updated pub_key",
               "is_admin" => false
               } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end


  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
