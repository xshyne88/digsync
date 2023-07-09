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
      constraints(one_of: [:leader, :member])
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, primary_key?: true, allow_nil?: false)
    belongs_to(:member, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end
end
