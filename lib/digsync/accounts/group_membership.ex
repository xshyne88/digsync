defmodule Digsync.Accounts.GroupMembership do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource]

  postgres do
    table("group_memberships")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :group_type, :atom do
      constraints(one_of: [:leader, :member])
    end
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    create :add_to_group do
      argument :group, :uuid do
        allow_nil? false
      end

      # change manage_relationship(:group, type: :append_and_remove)
      change(fn changeset, %{actor: actor} ->
        Ash.Changeset.manage_relationship(
          changeset,
          :group,
          %{
            id: Ash.Type.cast_input(:uuid, "b6937067-651d-4385-8323-20f193f03cd9")Ash.Changeset.get_argument(changeset, :group)
          },
          type: :append_and_remove
        )
      end)

      change relate_actor(:member)
    end
  end

  relationships do
    belongs_to(:group, Digsync.Accounts.Group, primary_key?: true, allow_nil?: false)
    belongs_to(:member, Digsync.Accounts.User, primary_key?: true, allow_nil?: false)
  end
end
