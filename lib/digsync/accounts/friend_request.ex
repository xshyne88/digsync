defmodule Digsync.Accounts.FriendRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("friend_requests")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    create :send_friendship_request do
      accept []

      argument :receiver, :uuid do
        allow_nil? false
      end

      change relate_actor(:sender)
      change manage_relationship(:receiver, type: :append_and_remove)
    end

    destroy :friend_request_response do
      argument :friendship_id, :uuid do
        allow_nil? false
      end
    end
  end

  relationships do
    belongs_to(:sender, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
    belongs_to(:receiver, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end

  identities do
    identity :unique_friend_request, [:sender_id, :receiver_id]
  end
end
