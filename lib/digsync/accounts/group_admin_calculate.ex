defmodule Digsync.Accounts.Calculations.GroupAdminOnGroup do
  use Ash.Calculation
  alias Digsync.Accounts.GroupMembership
  alias Digsync.Accounts
  require Ash.Query
  def init(opts), do: {:ok, opts}

  # calculate([Ash.Resource.record()], opts(), context()) ::
  # {:ok, [term()]} | [term()] | {:error, term()} | :unknown
  def calculate(records, _opts, %{actor: actor}) do
    ids = Enum.map(records, & &1.id)

    memberships =
      GroupMembership
      |> Ash.Query.filter(group_id in ^ids)
      |> Ash.Query.filter(member_id == ^actor.id)
      |> Ash.Query.select([:group_type])
      |> Accounts.read!(authorize?: false)
      |> Enum.map(&(&1.group_type == :admin))

    # {:ok, memberships}
    memberships
  end

  # def load(_query, _opts, _context) do
  #   [:group_id, :member_id]
  # end
end
