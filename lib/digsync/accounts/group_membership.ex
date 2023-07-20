defmodule Digsync.Accounts.GroupMembership do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource],
    authorizers: [Ash.Policy.Authorizer]

  alias Digsync.Accounts.Policies.IsGroupAdmin

  postgres do
    table("group_memberships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :group_type, :atom do
      default :member
      constraints(one_of: [:admin, :member])
    end
  end

  actions do
    defaults([:read, :update, :destroy])

    create :create do
      primary? true

      argument :group, :uuid do
        allow_nil? false
      end

      change manage_relationship(:group, type: :append_and_remove)
      change relate_actor(:member)
    end
  end

  policies do
    policy action_type(:create) do
      authorize_if IsGroupadmin
      # * Cannot use a filter to authorize a create.

      # If you are using Ash.Policy.Authorizer:

      # Many expressions, like those that reference relationships, require using custom checks for create actions.

      # Expressions that only reference the actor or context, for example `expr(^actor(:is_admin) == true)` will work
      # because those are evaluated without needing to reference data.

      # For create actions, there is no data yet. In the future we may support referencing simple attributes and those
      # references will be referring to the values of the data about to be created, but at this time we do not.

      #   Given a policy like:

      #   ```elixir
      #   policy expr(special == true) do
      #     authorize_if expr(allows_special == true)
      #   end
      #   ```

      #   You would rewrite it to not include create actions like so:

      #   ```elixir
      #   policy [expr(special == true), action_type([:read, :update, :destroy])] do
      #     authorize_if expr(allows_special == true)
      #   end
      #   ```

      #   At which point you could add a `create` specific policy:

      #   ```elixir
      #   policy [changing_attributes(special: [to: true]), action_type(:create)] do
      #     authorize_if changing_attributes(special: [to: true])
      #   end
      #   ```

      #   In these cases, you may also end up wanting to write a custom check.

      # authorize_if relates_to_actor_via([:group, :group_admin])
      # authorize_if expr()
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, allow_nil?: false)
    belongs_to(:member, Digsync.Accounts.User, allow_nil?: false)
  end

  identities do
    identity :unique_group_member, [:group_id, :member_id]
  end
end
