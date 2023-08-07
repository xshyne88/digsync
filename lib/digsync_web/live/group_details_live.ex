defmodule DigsyncWeb.GroupDetailsLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.Groups

  def mount(%{"group_id" => group_id}, _session, socket) do
    IO.puts("group id is #{group_id}")
    {:ok, group} = Groups.get(group_id)
    {:ok, assign(socket, group: clean_group(group))}
  end

  @display_fields [
    :id,
    :name
  ]

  defp clean_group(group) do
    group = Map.from_struct(group)

    group =
      Enum.reduce(group, %{}, fn
        {_key, nil}, acc -> acc
        {key, value}, acc when key in @display_fields -> Map.put(acc, key, to_string(value))
        {_, _}, acc -> acc
      end)
  end
end
