defmodule DigsyncWeb.Components.PrivatemessageDisplayComponent do
  @moduledoc """
    Display Component for Private Messages in a user's inbox.
  """
  use Phoenix.Component

  def private_message_container(assigns) do
    ~H"""
      <div class={"#{message_background_class(@author, @actor)} p-4 rounded-lg mb-4 relative"}>
      <div class="text-white mb-1 flex justify-between">
        <span class="text-sm"> <%= @author.first_name %></span>
        <span class="text-sm italic"> <%= format_inserted_at(@sent_at) %></span>
      </div>
      <div class="bg-white text-black p-3 rounded-lg text-sm">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  # TODO: Not use backend engineer for styling
  defp message_background_class(%{id: author_id}, %{id: actor_id}) when author_id == actor_id do
    "bg-red-400"
  end

  defp message_background_class(_, _), do: "bg-blue-400"

  defp format_inserted_at(inserted_at) do
    inserted_at
    |> Timex.format!("{YYYY}-{0M}-{0D} {h12}:{0m} {am}")
    |> to_string()
  end
end
