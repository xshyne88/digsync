defmodule DigsyncWeb.UserDetailsLive do
  use DigsyncWeb, :live_view

  alias Digsync.Accounts.Users

  @impl true
  def mount(%{"id" => user_id}, _session, socket) do
    {:ok, user} = Users.get(user_id)
    {:ok, assign(socket, user: sanitize_user(user))}
  end

  def handle_params(params, uri, socket) do
    IO.inspect(params, label: "params")
    {:noreply, socket}
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
    :skill_level,
    :id
  ]

  defp sanitize_user(nil), do: nil

  defp sanitize_user(user) do
    user
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {_key, nil}, acc -> acc
      {key, value}, acc when key in @display_fields -> Map.put(acc, key, to_string(value))
      {_, _}, acc -> acc
    end)
  end
end
