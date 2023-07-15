defmodule Digsync.Accounts.PrivateMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  alias Digsync.Accounts.Message
  alias Digsync.Accounts.Messages

  postgres do
    table("private_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:update, :destroy]

    read :read do
      primary? true

      prepare build(load: [message: Ash.Query.sort(Message, inserted_at: :desc)])
      filter(expr(recipient_id == ^actor(:id) or message.author_id == ^actor(:id)))
    end

    create :create do
      argument :recipient, :uuid do
        allow_nil? false
      end

      argument :message_text, :string do
        default ""
        allow_nil? false
      end

      change(fn changeset, %{actor: actor} ->
        Ash.Changeset.before_action(
          changeset,
          fn changeset ->
            text = Ash.Changeset.get_argument(changeset, :message_text)

            %{}
            |> Map.put(:text, text)
            |> Messages.create(actor: actor)
            |> case do
              {:ok, message} ->
                Ash.Changeset.manage_relationship(changeset, :message, message.id,
                  type: :append_and_remove
                )

              error ->
                error
            end
          end,
          prepend?: true
        )
      end)

      change manage_relationship(:recipient, type: :append_and_remove)
    end
  end

  attributes do
    uuid_primary_key(:id)
  end

  relationships do
    belongs_to(:message, Digsync.Accounts.Message, allow_nil?: false)
    belongs_to(:recipient, Digsync.Accounts.User, allow_nil?: false)
  end
end
