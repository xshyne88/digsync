defmodule Digsync.Accounts.Policies.IsGroupAdmin do
  use Ash.Policy.SimpleCheck

  alias Digsync.Accounts

  def describe(_) do
    "Check to see if the actor is a group admin of the group membership being accepted"
  end

  def match?(actor, %{resource: group_request} = stuff, opts) do
    # IO.inspect(stuff)
    # IO.inspect(opts)

    # group_admin_id =
    #   stuff.query |> Ash.Query.load(:group) |> Ash.Query.filter(group.group_admin_id == ^actor.id) |> 

    # actor.id == group_admin_id
    true
  end

  def match?(_, _, _), do: false |> IO.inspect(label: "bye dad")
end
