defmodule Digsync.Accounts.PrivateMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("private_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:read, :create, :update, :destroy]
  end

  attributes do
    uuid_primary_key(:id)
  end

  relationships do
    belongs_to(:message, Digsync.Accounts.Message, primary_key?: true, allow_nil?: false)
    belongs_to(:recipient, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end
end
