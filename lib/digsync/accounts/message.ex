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

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults [:read, :update, :destroy]

    read :read_by_author do
      argument :author_id, :uuid do
        allow_nil? false
      end

      filter(expr(author_id == arg(:author_id)))
    end

    create :create do
      primary? true
      change relate_actor(:author)
    end
  end

  relationships do
    belongs_to(:author, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity :unique_message_id, [:id]
  end
end
