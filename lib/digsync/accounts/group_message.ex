defmodule Digsync.Accounts.GroupMessage do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  alias Digsync.Accounts.Messages

  postgres do
    table("group_messages")
    repo(Digsync.Repo)
  end

  actions do
    defaults [:create, :update, :destroy]

    read :read do
      primary? true

      prepare build(load: :message)
    end

    create :create_from_scratch do
      touches_resources [Digsync.Accounts.Message]

      argument :group, :uuid do
        allow_nil? false
      end

      argument :message_text, :string do
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

      change manage_relationship(:group, type: :append_and_remove)
    end

    create :create_from_message do
      argument :group, :uuid do
        allow_nil? false
      end

      argument :message, :uuid do
        allow_nil? false
      end

      change manage_relationship(:group, type: :append_and_remove)
      change manage_relationship(:message, type: :append_and_remove)
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
