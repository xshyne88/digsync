defmodule Digsync.Accounts.Message do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:read, :create, :update, :destroy]
  end

  attributes do
    uuid_primary_key(:id)

    attribute :text, :string
  end

  # relationships do
  # belongs_to(:author, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  # end
end
