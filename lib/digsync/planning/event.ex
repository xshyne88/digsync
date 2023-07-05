defmodule Digsync.Planning.Event do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  import AshGeo.Validation

  postgres do
    table "events"
    repo Digsync.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :start_at, :utc_datetime
    attribute :end_at, :utc_datetime

    attribute :geo_point, :geometry
    attribute :address, :string

    attribute :description, :string do
      default ""
      constraints allow_empty?: false
    end

    create_timestamp :inserted_at
    create_timestamp :updated_at
  end

  actions do
    defaults [:read, :update, :destroy]

    create :create do
      argument :geo_point, :geo_any

      validate is_point(:geo_point)

      change set_attribute(:geo_point, arg(:geo_point))
    end
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
