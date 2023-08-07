defmodule Digsync.Accounts.Group do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshGraphql.Resource, AshAdmin.Resource]

  alias Digsync.Accounts.Calculations.GroupAdminOnGroup

  postgres do
    table("groups")
    repo(Digsync.Repo)
  end

  calculations do
    calculate(
      :admin?,
      :boolean,
      expr(
        exists(group_memberships, member_id == ^actor(:id)) and
          exists(group_memberships, group_type == :admin)
      )
    )
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)

      constraints(
        min_length: 3,
        trim?: true,
        allow_empty?: false
      )
    end

    attribute :description, :string do
      allow_nil?(false)
    end

    attribute :invite_only?, :boolean do
      default(false)
      allow_nil?(false)
    end

    attribute(:locaton, :string)

    attribute(:preferred_location, :string)

    attribute :type, :atom do
      default(:social)
      constraints(one_of: [:club, :bar, :social])
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:read, :update, :destroy])

    read :with_members do
      prepare build(load: :group_memberships)
    end

    create :create do
      change(fn changeset, %{actor: actor} ->
        Ash.Changeset.after_action(changeset, fn changeset, group ->
          Digsync.Accounts.GroupMembership
          |> Ash.Changeset.for_create(:group_created, %{group: group.id}, actor: actor)
          |> Digsync.Accounts.create()
          |> case do
            {:ok, _} ->
              {:ok, group}

            error ->
              error
          end
        end)
      end)

      change(relate_actor(:creator))
    end
  end

  identities do
    identity(:unique_group_name, [:name])
    identity(:unique_group_id, [:id])
  end

  calculations do
    calculate(:is_group_admin?, :boolean, {GroupAdminOnGroup, []})
  end

  relationships do
    belongs_to(:creator, Digsync.Accounts.User, allow_nil?: false)

    many_to_many :group_members, Digsync.Accounts.User do
      through(Digsync.Accounts.GroupMembership)
      join_relationship(:group_memberships)
      destination_attribute_on_join_resource(:member_id)
      source_attribute_on_join_resource(:group_id)
    end
  end
end
