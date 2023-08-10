defmodule Digsync.Accounts.UserTest do
  use Digsync.DataCase
  import Digsync.Factory

  alias Digsync.Accounts.User

  describe "actions" do
    test "create" do
      user1 = build_user()

      assert Enum.count(Accounts.read!(User)) == 1
      assert %User{} = user1
    end
  end
end
