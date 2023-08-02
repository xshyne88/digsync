defmodule Digsync.Accounts.GroupMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  # alias Digsync.Accounts.Messages

  postgres do
    table("group_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:destroy]

    read :read do
      primary? true

      prepare build(load: :message)
    end

    create :create do
      touches_resources [Digsync.Accounts.Message]

      argument :group, :uuid do
        allow_nil? false
      end

      argument :message_text, :string do
        allow_nil? false
      end

      change manage_relationship(:message_text, :message, type: :create, value_is_key: :text)
      change manage_relationship(:group, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key(:id)

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  relationships do
    belongs_to(:message, Digsync.Accounts.Message, allow_nil?: false)
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
  end
end
