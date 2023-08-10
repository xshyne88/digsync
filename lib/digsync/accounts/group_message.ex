defmodule Digsync.Accounts.GroupMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("group_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:destroy]

    read :read do
      primary? true
    end

    create :create do
      argument :group, :uuid do
        allow_nil? false
      end

      argument :text, :string do
        allow_nil? false
      end

      change manage_relationship(:group, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :text, :string do
      constraints(allow_empty?: false)
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
  end
end
