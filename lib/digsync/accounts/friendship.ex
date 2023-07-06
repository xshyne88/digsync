defmodule Digsync.Accounts.Friendship do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("friendships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :friendship_type, :atom do
      default :pending_first_second

      constraints(
        one_of: [
          :pending_first_second,
          :pending_second_first,
          :friends,
          :block_first_second,
          :block_second_first,
          :block_both
        ]
      )
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :update, :destroy])
  end

  # relationships do
  #   belongs_to :user, Digsync.Accounts.User, primary_key?: true, allow_nil?: false
  #   belongs_to :user, Digsync.Accounts.User, primary_key?: true, allow_nil?: false
  # end
end
