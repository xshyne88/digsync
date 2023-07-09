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

      constraints max_length: 20,
                  min_length: 3,
                  match: ~r/^[a-z_-]*$/,
                  trim?: true,
                  allow_empty?: false
    end

    attribute :description, :string do
      allow_nil? false
    end

    attribute :locaton, :string

    attribute :preferred_location, :string

    attribute :type, :atom do
      constraints one_of: [:club, :bar, :social]
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :update, :destroy])
  end

  identities do
    identity(:unique_group_name, [:name])
  end

  relationships do
    belongs_to(:creator, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)

    # has_many :messages, Digsync.Accounts.Message

    many_to_many :group_members, Digsync.Accounts.User do
      through(Digsync.Accounts.GroupMembership)
      destination_attribute_on_join_resource(:group_id)
      source_attribute_on_join_resource(:member_id)
    end
  end
end
