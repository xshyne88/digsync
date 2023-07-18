defmodule Digsync.Accounts.GroupRequest do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  # authorizers: [Ash.Policy.Authorizer]

  # alias Digsync.Accounts.Policies.IsGroupAdmin

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

      filter(expr(group.group_admin_id == ^actor(:id)))
    end

    read :get_by_requester_and_group do
      get?(true)

      argument :group, :uuid do
        allow_nil?(false)
      end

      argument :requester, :uuid do
        allow_nil?(false)
      end

      filter(requester_id: arg(:requester), group_id: arg(:group))
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

  # code_interface do
  #   define_for Digsync.Accounts

  #   define :group_by_member
  # end

  # policies do
  #   policy action(:create) do
  #     authorize_if always()
  #   end

  #   policy action(:read) do
  #     authorize_if(relates_to_actor_via(:requester))
  #     authorize_if(relates_to_actor_via([:group, :group_admin]))
  #   end
  # end

  identities do
    identity(:unique_group_request, [:group_id, :requester_id])
  end
end
