defmodule Digsync.Accounts.Flows.CreateFriendship do
  use Ash.Flow, otp_app: :digsync

  flow do
    api Digsync.Accounts

    description "A transaction for deleting a friend request and creating a friendship"

    argument :friendship_id, :uuid do
      allow_nil? false
    end
  end

  steps do
    transaction :create_friend_tx do
      read :get_friend_request, Digsync.Accounts.FriendRequest, :read do
        get? true
      end

      destroy :destroy_friendship_request,
              Digsync.Accounts.FriendRequest,
              :friend_request_response do
        input %{
          friendship_id: path(result(:get_friend_request), [:id])
        }

        record result(:get_friend_request)
      end

      create :create_friendship, Digsync.Accounts.Friendship, :create_from_flow do
        input %{
          friend_one: path(result(:get_friend_request), [:sender_id]),
          friend_two: path(result(:get_friend_request), [:receiver_id])
        }
      end
    end
  end
end
