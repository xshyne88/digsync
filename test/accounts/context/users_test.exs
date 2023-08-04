defmodule Digsync.Accounts.UsersTest do
  use Digsync.DataCase

  import Digsync.Fixtures.User

  alias Digsync.Accounts.User
  alias Digsync.Accounts.Users

  describe "list_all" do
    test "gets all users" do
      user1 = build_user()
      user2 = build_user()

      {:ok, result} = Users.list_all()

      assert Enum.count(result) == 2
      assert Enum.all?(result, fn user -> user.id in [user1.id, user2.id] end)
    end
  end

  describe "create" do
    test "can create a user" do
      actor = build_user()

      params = %{
        first_name: "Stewie",
        last_name: "Griffin",
        email: "familyguy@gmail.com",
        hashed_password: "acb231"
      }

      Users.create(params, actor)

      users = User |> Accounts.read!()

      assert Enum.any?(users, fn user -> user.first_name == params[:first_name] end)
    end
  end

  describe "update" do
    test "can update a user" do
      actor = build_user()
      user = build_user()
      params = %{first_name: "new monkey"}

      refute user.first_name == params[:first_name]

      Users.update(user, params, actor)

      updated_users = User |> Accounts.read!()
      assert Enum.any?(updated_users, fn user -> user.first_name == params[:first_name] end)
    end
  end
end
