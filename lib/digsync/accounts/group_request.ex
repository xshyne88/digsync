defmodule Digsync.Accounts.GroupRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Digsync.Accounts.Policies.IsGroupAdmin

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
      argument :group, :uuid do
        allow_nil?(false)
      end
    end

    read :by_requester do
      argument :group, :uuid do
        allow_nil? false
      end

      argument :requester, :uuid do
        allow_nil? false
      end

      filter(expr(requester_id == ^arg(:requester) and group_id == ^arg(:group)))
    end

    create :create do
      accept([])

      argument :group, :uuid do
        allow_nil?(false)
      end

      change(relate_actor(:requester))
      change(manage_relationship(:group, type: :append_and_remove))
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
    belongs_to(:requester, Digsync.Accounts.User, allow_nil?: false)
  end

  policies do
    policy action(:create) do
      authorize_if IsGroupAdmin
    end

    policy action(:read) do
      authorize_if expr(group.group_admin_id == ^actor(:id) or requester_id == ^actor(:id))
    end
  end

  code_interface do
    define_for Digsync.Accounts

    define :by_requester, args: [:requester, :group]
  end

  identities do
    identity(:unique_group_request, [:group_id, :requester_id])
  end
end
