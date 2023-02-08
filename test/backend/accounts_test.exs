defmodule Backend.AccountsTest do
  use Backend.DataCase

  alias Backend.Accounts

  describe "users" do
    alias Backend.Accounts.User

    import Backend.AccountsFixtures

    @invalid_attrs %{balance: nil, code: nil, phone_number: nil, pub_key: nil, is_admin: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{balance: 120.5, code: "some code", phone_number: "some phone_number", pub_key: "some pub_key", is_admin: false}
      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.balance == 120.5
      assert user.code == "some code"
      assert user.phone_number == "some phone_number"
      assert user.pub_key == "some pub_key"
      assert user.is_admin  == false
    end

    test "create_user_with_code/1 with valid data creates a user" do
      valid_attrs = %{"balance" => 120.5, "code" => "some code", "phone_number" => "some phone_number", "pub_key" => "some pub_key", "is_admin" => false}
      assert {:ok, %User{} = user} = Accounts.create_user_code(valid_attrs)
      assert user.balance == 120.5
      assert user.code != "some code"
      assert user.phone_number == "some phone_number"
      assert user.pub_key == "some pub_key"
      assert user.is_admin  == false
    end


    test "get pubkey / is exist" do
      valid_attrs = %{balance: 120.5, code: "some code", phone_number: "some phone_number", pub_key: "some pub_key", is_admin: false}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.balance == 120.5
      assert user.code == "some code"
      assert user.phone_number == "some phone_number"
      assert user.pub_key == "some pub_key"
      assert user.is_admin  == false
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{balance: 456.7, code: "some updated code", phone_number: "some updated phone_number", pub_key: "some updated pub_key", is_admin: false}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.balance == 456.7
      assert user.code == "some updated code"
      assert user.phone_number == "some updated phone_number"
      assert user.pub_key == "some updated pub_key"
      assert user.is_admin == false
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end

    test "get pub_key/returns pub_key" do
      user = user_fixture()
      phone_number = "some phone_number"
      assert {:ok, %User{} = user} = Accounts.get_user_by_phone_number(phone_number)
      assert user.balance == 120.5
      assert user.code == "some code"
      assert user.phone_number == "some phone_number"
      assert user.pub_key == "some pub_key"
      assert user.is_admin  == false
    end

    test "get pub_key/returns nil" do
      user = user_fixture()
      phone_number = "some rand phone_number"
      assert {:error, :not_found} = Accounts.get_user_by_phone_number(phone_number)
    end


  end
end
