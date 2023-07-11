defmodule Digsync.Accounts.Message do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("messages")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :text, :string
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      primary? true
      change relate_actor(:creator)
    end
  end

  relationships do
    belongs_to(:creator, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end

  identities do
    identity :unique_message_id, [:id]
  end
end
