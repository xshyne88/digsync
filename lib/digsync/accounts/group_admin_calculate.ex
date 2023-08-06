defmodule Digsync.Accounts.Calculations.GroupAdminOnGroup do
  use Ash.Calculation
  alias Digsync.Accounts.GroupMembership
  alias Digsync.Accounts
  require Ash.Query
  def init(opts), do: {:ok, opts}

  def calculate(records, _opts, %{actor: actor}) do
    ids = Enum.map(records, & &1.id)

    GroupMembership
    |> Ash.Query.filter(group_id in ^ids)
    |> Ash.Query.filter(member_id == ^actor.id)
    |> Ash.Query.select([:group_type])
    |> Accounts.read!(authorize?: false)
    |> Enum.map(&(&1.group_type == :admin))
  end
end
