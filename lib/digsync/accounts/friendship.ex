defmodule Digsync.Accounts.Friendship do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  alias Digsync.Accounts.FriendRequests

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

    create :accept_friend_request do
      touches_resources [:friend_request]

      argument :sender, :uuid do
        allow_nil? false
      end

      change(fn changeset, %{actor: actor} ->
        Ash.Changeset.before_action(changeset, fn changeset ->
          sender = Ash.Changeset.get_argument(changeset, :sender)

          with {:ok, friend_request} <- FriendRequests.get_by_sender(sender),
               {:ok, _destroyed} <- FriendRequests.accepted(friend_request) do
            type = :append_and_remove

            changeset
            |> Ash.Changeset.manage_relationship(:friend_one, %{id: sender}, type: type)
            |> Ash.Changeset.manage_relationship(:friend_two, %{id: actor.id}, type: type)
          else
            error -> error
          end
        end)
      end)
    end
  end

  relationships do
    belongs_to(:friend_one, Digsync.Accounts.User, allow_nil?: false)
    belongs_to(:friend_two, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity :unique_friendship, [:friend_one_id, :friend_two_id]
  end
end
