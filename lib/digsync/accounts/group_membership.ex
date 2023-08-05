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

  calculations do
    calculate :member_email,
              :string,
              fn gm, ctx -> gm.member.email end do
      load(member: [:email])
      description "normalize email to see who they are"
    end

    calculate :group_name,
              :string,
              fn gm, ctx -> gm.group.name end do
      load(group: [:name])
      description "normalize group name"
    end
  end

  actions do
    defaults([:update, :destroy])

    read :read do
      description "only admins and group members can see other group members"
      primary?(true)
      prepare build(load: [:member_email, :group_name])
      filter(expr(^actor(:id) == member_id or group_type == :admin))
    end

    create :group_created do
      description "this action is used from the groups resource when it is created"

      argument :group, :uuid do
        allow_nil?(false)
      end

      change(set_attribute(:group_type, :admin))
      change(manage_relationship(:group, type: :append_and_remove))
      change(relate_actor(:member))
    end

    create :seed_create do
      argument :group, :uuid do
        allow_nil? false
      end

      change(manage_relationship(:group, type: :append_and_remove))
      change(relate_actor(:member))
    end

    create :create do
      description "lookup group request and destroy it before creating group membership record"
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
