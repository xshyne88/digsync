defmodule Digsync.Accounts.Friendship do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("friendships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    create :create_from_flow do
      argument :friend_one, :uuid do
        allow_nil? false
      end

      argument :friend_two, :uuid do
        allow_nil? false
      end

      change manage_relationship(:friend_one, type: :append_and_remove)
      change manage_relationship(:friend_two, type: :append_and_remove)
    end
  end

  relationships do
    belongs_to(:friend_one, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
    belongs_to(:friend_two, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end

  identities do
    identity :unique_friendship, [:friend_one_id, :friend_two_id]
  end
end
