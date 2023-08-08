defmodule Digsync.Accounts.Policies.CanAccessGroup do
  use Ash.Policy.SimpleCheck

  alias Digsync.Accounts
  alias Digsync.Accounts.GroupMembership

  def describe(_) do
    "Check to see if the actor is a group admin"
  end

  def match?(actor, %{
        resource: GroupMembership,
        action: %{name: :create},
        changeset: changeset
      }) do
    changeset
    |> get_group()
    |> find_membership(actor)
    |> is_group_member?(find_admin?: true)
  end

  def match?(_actor, %{
        resource: GroupMembership,
        action: %{name: :destroy},
        changeset: _changeset
      }) do
    true
  end

  def match?(
        actor,
        %{
          resource: GroupMembership,
          action: %{name: :read},
          query: %{arguments: %{group: group}}
        },
        _opts
      ) do
    group
    |> find_membership(actor)
    |> is_group_member?(find_admin?: false)
  end

  def match?(_actor, _params, _opts) do
    false
  end

  defp get_group(changeset) do
    changeset
    |> Ash.Changeset.get_argument(:group_request)
    |> then(&(GroupRequest |> Accounts.get!(&1)))
    |> Map.get(:group_id)
  end

  defp find_membership(group, actor) do
    GroupMembership
    |> Ash.Query.for_read(:my_membership, %{group: group}, actor: actor, authorize?: false)
    |> Accounts.read_one()
  end

  defp is_group_member?({:ok, %GroupMembership{group_type: :admin}}, find_admin?: true), do: true
  defp is_group_member?({:ok, %GroupMembership{}}, find_admin?: false), do: true
  defp is_group_member?(_, _), do: false
end
