defmodule Digsync.Accounts.Policies.IsGroupAdmin do
  use Ash.Policy.SimpleCheck

  alias Digsync.Accounts
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.GroupRequest
  alias Digsync.Accounts.GroupMembership

  def describe(_) do
    "Check to see if the actor is a group admin"
  end

  def match?(actor, %{resource: GroupRequest, changeset: changeset}, _opts) do
    group = get_group(changeset)
    IO.inspect(actor, label: "actor")

    group.group_admin_id == actor.id
  end

  def match?(actor, %{resource: GroupMembership, changeset: changeset}, _opts) do
    group = get_group(changeset)

    group.group_admin_id == actor.id
  end

  def match?(actor, params, opts) do
    false
  end

  defp get_group(changeset) do
    changeset
    |> Ash.Changeset.get_argument(:group)
    |> then(&(Group |> Accounts.get!(&1)))
  end
end
