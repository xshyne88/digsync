defmodule Digsync.Accounts.FriendRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("friend_requests")
    repo(Digsync.Repo)
  end

  # resource do
  #   base_filter is_nil: :deleted_at
  # end

  attributes do
    uuid_primary_key(:id)

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
    create_timestamp(:deleted_at, private?: false, allow_nil?: true)
  end

  actions do
    defaults([:create, :read, :update])

    create :send_friendship_request do
      accept []

      argument :receiver, :uuid do
        allow_nil? false
      end

      change relate_actor(:sender)
      change manage_relationship(:receiver, type: :append_and_remove)
    end

    read :by_receiver do
      get?(true)

      argument :receiver_id, :uuid do
        allow_nil? false
      end

      filter(receiver_id: arg(:receiver_id), sender_id: actor(:id))
    end

    destroy :friend_request_response do
      change set_attribute(:deleted_at, &DateTime.utc_now/0)
      soft? true
    end
  end

  relationships do
    belongs_to(:sender, Digsync.Accounts.User, allow_nil?: false)
    belongs_to(:receiver, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity :unique_friend_request, [:sender_id, :receiver_id]
  end
end
