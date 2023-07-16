defmodule Digsync.Accounts.FriendRequestTest do
  use Digsync.DataCase
  import Digsync.Factory

  alias Digsync.Accounts.User

  describe "actions" do
    test ":send_friendship_request" do
      insert(:user)
      assert 1 == 1
    end
  end
end
