defmodule Digsync.Accounts.Location do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshAdmin.Resource]

  postgres do
    table("locations")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute :directions, :string do
      allow_nil?(false)
    end

    attribute :type, :atom do
      default(:grass)
      constraints(one_of: [:grass, :sand, :indoor])
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:read, :update, :destroy])

    create :create do
      change(relate_actor(:creator))
    end
  end

  # identities do

  # end

  relationships do
    belongs_to(:creator, Digsync.Accounts.User, allow_nil?: false)
  end
end
