defmodule Digsync.Accounts.Group do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("groups")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil? false

      constraints min_length: 3,
                  trim?: true,
                  allow_empty?: false
    end

    attribute :description, :string do
      allow_nil? false
    end

    attribute :locaton, :string

    attribute :preferred_location, :string

    attribute :type, :atom do
      default :social
      constraints one_of: [:club, :bar, :social]
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:read, :update, :destroy])

    create :actor_create do
      change relate_actor(:creator)
    end
  end

  identities do
    identity(:unique_group_name, [:name])
    identity(:uniq_id, [:id])
  end

  relationships do
    belongs_to(:creator, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)

    many_to_many :group_members, Digsync.Accounts.User do
      through(Digsync.Accounts.GroupMembership)
      destination_attribute_on_join_resource(:group_id)
      source_attribute_on_join_resource(:member_id)
    end
  end
end
