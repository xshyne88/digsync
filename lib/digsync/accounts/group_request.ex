defmodule Digsync.Accounts.GroupRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("group_requests")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
    create_timestamp(:deleted_at, private?: false, allow_nil?: true)
  end

  actions do
    defaults([:update, :destroy])

    read :read do
      primary? true

      argument :group, :uuid do
        allow_nil?(false)
      end

      filter(expr(requester.id == ^actor(:id)))
    end

    read :all do
    end

    read :by_id do
      get_by :id
    end

    create :create do
      accept([])

      argument :group, :uuid do
        allow_nil?(false)
      end

      change(relate_actor(:requester))
      change(manage_relationship(:group, type: :append_and_remove))
    end

    destroy :soft do
      change set_attribute(:deleted_at, &DateTime.utc_now/0)
      soft? true
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
    belongs_to(:requester, Digsync.Accounts.User, allow_nil?: false)
  end

  code_interface do
    define_for Digsync.Accounts

    define :read, args: [:group]
  end

  identities do
    identity(:unique_group_request, [:group_id, :requester_id])
  end
end
