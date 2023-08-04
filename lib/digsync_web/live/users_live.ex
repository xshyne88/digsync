defmodule DigsyncWeb.UsersLive do
  use DigsyncWeb, :live_view

  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.Users

  def mount(_params, _session, socket) do
    initial_sort = "asc"
    {:ok, assign(socket, users: fetch_users(initial_sort), sort_order: initial_sort)}
  end

  def handle_event("toggle_sort_order", %{"sort_order" => sort_order}, socket) do
    new_sort_order = toggle_sort_order(sort_order)

    {:noreply, assign(socket, users: fetch_users(new_sort_order), sort_order: new_sort_order)}
  end

  defp toggle_sort_order("asc"), do: "desc"
  defp toggle_sort_order("desc"), do: "asc"

  defp fetch_users(sort_order) when is_binary(sort_order) do
    sort_order
    |> String.to_atom()
    |> fetch_users()
  end

  defp fetch_users(sort_order) do
    sort_order
    |> Users.list_all()
    |> case do
      {:ok, users} ->
        users

      # ignore errors for now
      _ ->
        nil
    end
    |> sanitize_users()
  end

  @display_fields [
    :address,
    :age,
    :bio,
    :email,
    :facebook_link,
    :first_name,
    :gender,
    :github_link,
    :instagram_link,
    :last_name,
    :linkedin_link,
    :phone_number,
    :skill_level
  ]

  defp sanitize_users(nil), do: nil

  defp sanitize_users(users) do
    Enum.map(users, fn user ->
      user
      |> Map.from_struct()
      |> Enum.reduce(%{}, fn
        {_key, nil}, acc -> acc
        {key, value}, acc when key in @display_fields -> Map.put(acc, key, to_string(value))
        {_, _}, acc -> acc
      end)
    end)
  end
end
