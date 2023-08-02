defmodule Digsync.Accounts.GroupMembership do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Digsync.Accounts.Policies.IsGroupAdmin
  alias Digsync.Accounts.GroupRequests

  postgres do
    table("group_memberships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :group_type, :atom do
      default(:member)
      constraints(one_of: [:admin, :member])
    end
  end

  actions do
    defaults([:update, :destroy])

    read :read do
      primary?(true)
      filter(expr(^actor(:id) == member_id or group_type == :admin))
    end

    create :group_created do
      description("""
      Creates a GroupMembership for a newly created group
      """)

      argument :group, :uuid do
        allow_nil?(false)
      end

      change(set_attribute(:group_type, :admin))
      change(manage_relationship(:group, type: :append_and_remove))
      change(relate_actor(:member))
    end

    create :create do
      primary?(true)

      argument :group_request, :uuid do
        allow_nil?(false)
      end

      change(fn changeset, %{actor: actor} ->
        Ash.Changeset.before_action(changeset, fn changeset ->
          group_request_id = Ash.Changeset.get_argument(changeset, :group_request)

          with {:ok, group_request} <- GroupRequests.get(group_request_id),
               {:ok, _destroyed} <- GroupRequests.accepted(group_request) do
            type = :append_and_remove

            changeset
            |> Ash.Changeset.manage_relationship(:member, %{id: group_request.requester.id},
              type: type
            )
            |> Ash.Changeset.manage_relationship(:group, %{id: group_request.group.id}, type: type)
          else
            error -> error
          end
        end)
      end)
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if(IsGroupAdmin)
    end

    policy action(:read) do
      authorize_if(always())
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
    belongs_to(:member, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity(:unique_group_member, [:group_id, :member_id])
  end
end
