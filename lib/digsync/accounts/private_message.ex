defmodule Digsync.Accounts.PrivateMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  alias __MODULE__

  postgres do
    table("private_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults([:update, :destroy])

    read :read do
      primary?(true)

      # prepare(build(sort: [inserted_at: :asc]))
      # prepare(build(distinct: [:author_id]))
      filter(expr(recipient_id == ^actor(:id) or author_id == ^actor(:id)))
    end

    read :preview do
      prepare(build(sort: [inserted_at: :asc]))

      argument :who, :uuid do
        allow_nil? false
      end

      # modify_query fn ash, ecto ->
      #   actor_id = Ash.Query.get_argument(ash, :who)

      #   require Ecto.Query
      #   import Ecto.Query

      #   query =
      #     from p in PrivateMessages,
      #       where: p.recipient_id == ^recipient_id or p.author_id == ^author_id,
      #       group_by: [p.author_id, p.recipient_id],

      #       {:ok, query}
      # end

      filter(expr(recipient_id == ^actor(:id) or author_id == ^actor(:id)))
    end

    create :create do
      primary?(true)
      accept([:text, :inserted_at])

      argument :recipient, :uuid do
        allow_nil?(false)
      end

      change(relate_actor(:author))
      change(manage_relationship(:recipient, type: :append_and_remove))
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
    belongs_to(:recipient, Digsync.Accounts.User, allow_nil?: false)
    belongs_to(:author, Digsync.Accounts.User, allow_nil?: false)
  end
end
