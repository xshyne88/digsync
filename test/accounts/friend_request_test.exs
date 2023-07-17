defmodule Digsync.Accounts.FriendRequestTest do
  use Digsync.DataCase
  import Digsync.UserFixtures

  alias Digsync.Accounts
  alias Digsync.Accounts.FriendRequest

  describe "actions" do
    test "create" do
      user1 = build_user()
      user2 = build_user()

      fr =
        FriendRequest
        |> Ash.Changeset.for_create(:create, %{receiver: user2.id}, actor: user1)
        |> Accounts.create!()
        |> IO.inspect()

      assert fr.receiver_id == user2.id
      assert fr.sender_id == user1.id
    end
  end
end
