defmodule DigsyncWeb.GroupDetailsLive do
  alias DigsyncWeb.GroupsLive
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Groups
  require Logger
  alias DigsyncWeb.Router.Helpers, as: Routes

  def mount(%{"group_id" => group_id}, _session, socket) do
    case Groups.get_by_id(group_id, socket.assigns.current_user) do
      nil ->
        Logger.debug("failed to get a group with id #{group_id}")
        socket = push_navigate(socket, to: Routes.live_path(socket, GroupsLive))
        {:error, socket}
      group ->
        {:ok, assign(socket, group: clean_group(group))}
    end
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

    group
  end
end
