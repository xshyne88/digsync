defmodule DigsyncWeb.UsersLive do
  use DigsyncWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, users: Digsync.Accounts.read!(Digsync.Accounts.User), sort_order: "asc")

    {:ok, socket}
  end

  def handle_event("toggle_sort_order", _, socket) do
    current_order = Map.get(socket.assigns, :sort_order, "asc")
    new_order = if current_order == "asc", do: "desc", else: "asc"
    updated_socket = assign(socket, :sort_order, new_order)

    # Perform user sorting based on the new_order in the assigns
    sorted_users =
      if new_order == "asc" do
        Enum.sort_by(updated_socket.assigns.users, &String.downcase(&1.first_name))
      else
        Enum.sort_by(updated_socket.assigns.users, &String.downcase(&1.first_name), :desc)
      end

    # Update the socket assigns with the sorted users list
    updated_socket = assign(updated_socket, :users, sorted_users)

    {:noreply, updated_socket}
  end
end
