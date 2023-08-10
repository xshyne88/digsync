defmodule DigsyncWeb.MessageInboxLive do
  @moduledoc """
    Display page for showing all of a user's private messages.
  """
  use DigsyncWeb, :live_view

  import DigsyncWeb.Components.PrivatemessageDisplayComponent

  alias Digsync.Accounts
  alias Digsync.Accounts.PrivateMessage

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user
    messages = get_private_messages(current_user)
    {:ok, assign(socket, actor: current_user, messages: messages)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded-lg shadow-md">
      <h1 class="text-4xl font-bold mb-4 text-black">My Inbox</h1>
      <div>
        <%= for private_message <- @messages do %>
          <.private_message_container
            author={private_message.author}
            sent_at={private_message.inserted_at}
            actor={@actor}
          >
            <%= private_message.text %>
          </.private_message_container>
        <% end %>
      </div>
    </div>
    """
  end

  defp get_private_messages(actor) do
    require Logger

    PrivateMessage
    # TODO: Figure out why I have to use set_actor in query to load
    |> Ash.Query.set_actor(actor: actor)
    # |> Ash.Query.distinct_sort(inserted_at: :desc)
    |> Ash.Query.load(:author)
    # |> Ash.Query.distinct(:author_id)
    # |> Ash.Query.for_read(:preview, %{who: actor.id})
    |> Ash.Query.for_read(:read)
    |> Accounts.read()
    |> case do
      {:ok, messages} ->
        messages

      result ->
        # TODO: properly handle message failure
        Logger.error(inspect(result))
        []
    end
  end
end
