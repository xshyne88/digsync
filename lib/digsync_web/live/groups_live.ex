defmodule DigsyncWeb.GroupsLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Group
  alias Digsync.Accounts
  alias Digsync.Accounts.Users
  alias DigsyncWeb.Router.Helpers, as: Routes
  alias DigsyncWeb.GroupDetailsLive
  alias DigsyncWeb.CreateGroupLive

  def mount(_params, _session, socket) do
    # pass in groups + creator
    groups = fetch_groups()
    socket = assign(socket, groups_to_creators: get_map_groups_to_creators())
    {:ok, socket}
  end

  def handle_event("view_group", %{"group_id" => group_id}, socket) do
    socket = push_navigate(socket, to: Routes.live_path(socket, GroupDetailsLive, group_id))
    {:noreply, socket}
  end

  def handle_event("create_group", _, socket) do
    socket = push_navigate(socket, to: Routes.live_path(socket, CreateGroupLive))
    {:noreply, socket}
  end

  @display_fields [
    :id,
    :creator_id,
    :name
  ]

  defp sanitize_groups(groups) do
    Enum.map(groups, fn group ->
      group
      |> Map.from_struct()
      |> Enum.reduce(%{}, fn
        {_key, nil}, acc -> acc
        {key, value}, acc when key in @display_fields -> Map.put(acc, key, to_string(value))
        {_, _}, acc -> acc
      end)
    end)
  end

  defp fetch_groups() do
    Group
    |> Accounts.read!()
    |> sanitize_groups()
  end

  def get_map_groups_to_creators() do
    groups = fetch_groups()
    Enum.map(groups, fn group -> {group, elem(Users.get(group[:creator_id]), 1)} end)
  end
end
