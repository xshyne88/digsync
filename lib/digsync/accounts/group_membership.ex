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
    defaults([:read, :update, :destroy])

    create :create do
      primary? true

      argument :group, :uuid do
        allow_nil? false
      end

      argument :member, :uuid do
        allow_nil? false
      end

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
      authorize_if IsGroupadmin
    end

    policy action(:read) do
      authorize_if expr(
                     group.group_admin_id == ^actor(:id) or requester_id == ^actor(:id) or
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
