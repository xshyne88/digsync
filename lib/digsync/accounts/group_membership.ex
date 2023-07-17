defmodule Digsync.Accounts.GroupMembership do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

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

      change manage_relationship(:group, type: :append_and_remove)
      change relate_actor(:member)
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
