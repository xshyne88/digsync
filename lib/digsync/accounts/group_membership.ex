defmodule Digsync.Accounts.GroupMembership do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Digsync.Accounts.Policies.IsGroupAdmin

  postgres do
    table("group_memberships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :group_type, :atom do
      default :member
      constraints(one_of: [:admin, :member])
    end
  end

  actions do
    defaults([:update, :destroy])

    read :read do
      filter(expr(^actor(:id) == member_id or group_type == :admin))
    end

    # read :by_group do
    #   argument :group, :uuid do
    #     allow_nil? false
    #   end

    #   filter expr()
    # end

    create :create do
      primary? true

      argument :group, :uuid do
        allow_nil? false
      end

      argument :member, :uuid do
        allow_nil? false
      end

      # TODO:
      # we need to first take in the group_request id, which will be present on the frontend
      # we could also create an action that takes in a group and member
      # we need to validate that the actor is a group admin
      # we need to check the membership of the actor to see if they are an admin type
      # we need to lookup the group request and soft delete it.
      # we then need to relate the member and group from the group request

      # change(fn changeset, %{actor: actor} ->
      #   Ash.Changeset.before_action(changeset, fn changeset ->
      #     member = Ash.Changeset.get_argument(changeset, :member)
      #     group = Ash.Changeset.get_argument(changeset, :group)

      #     with {:ok, friend_request} <-
      #            Accounts.group_request_by_member(%{member: member, group: group}),
      #          {:ok, _destroyed} <- FriendRequests.accepted(friend_request) do
      #       type = :append_and_remove

      #       changeset
      #       |> Ash.Changeset.manage_relationship(:friend_one, %{id: sender}, type: type)
      #       |> Ash.Changeset.manage_relationship(:friend_two, %{id: actor.id}, type: type)
      #     else
      #       error -> error
      #     end
      #   end)
      # end)

      change manage_relationship(:group, type: :append_and_remove)
      change relate_actor(:member)
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if IsGroupAdmin
    end

    policy action(:read) do
      authorize_if expr(
                     group.group_admin_id == ^actor(:id) or member_id == ^actor(:id) or
                       group_type == :admin
                   )
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
    belongs_to(:member, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity :unique_group_member, [:group_id, :member_id]
  end
end
