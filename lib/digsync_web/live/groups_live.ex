defmodule DigsyncWeb.GroupsLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Groups
  alias DigsyncWeb.Router.Helpers, as: Routes
  alias DigsyncWeb.GroupDetailsLive
  alias DigsyncWeb.CreateGroupLive
  require Ash.Query

  def mount(_params, _session, socket) do
    socket = assign(socket, groups: fetch_groups(socket.assigns.current_user))
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


  defp sanitize_groups(groups) do
    # Create a map of
    Enum.map(groups, fn group ->
      %{creator_first_name: group.creator.first_name, creator_last_name: group.creator.last_name, id: group.id, name: group.name} end)
  end

  defp fetch_groups(current_user) do
    Groups.all_groups(current_user, [:creator])
    |> case do
      {:ok, groups} -> groups
      _ -> nil
    end
    |> sanitize_groups()
  end
end
