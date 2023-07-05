
defmodule Digsync.Planning.Event do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

    postgres do
      table "events"
      repo Digsync.Repo
    end

    attributes do
      uuid_primary_key :id

      attribute :start_at, :utc_datetime
      attribute :end_at, :utc_datetime

      attribute :description, :string do
        default ""
        constraints allow_empty?: false
      end

      create_timestamp :inserted_at
      create_timestamp :updated_at
    end

    actions do
      defaults [:create, :read, :update, :destroy]
    end

    graphql do
      type :event
      queries do
        get(:get_event, :read)

        list(:list_events, :read)
      end

      mutations do
        create :create_event, :create
        update :update_event, :update
        destroy :destroy_event, :destroy
      end
    end
  end
