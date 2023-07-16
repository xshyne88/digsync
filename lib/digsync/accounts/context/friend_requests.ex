defmodule Digsync.Accounts.FriendRequests do
  alias Digsync.Accounts
  alias Digsync.Accounts.FriendRequest

  require Ash.Query

  def get_by_sender(sender) do
    FriendRequest
    |> Ash.Query.for_read(:by_sender, %{sender: sender})
    |> Accounts.read_one()
  end

  def accepted(%FriendRequest{} = friend_request) do
    friend_request
    |> Ash.Changeset.for_destroy(:friend_request_response)
    |> Accounts.destroy()
    |> case do
      :ok -> {:ok, friend_request}
      error -> error
    end
  end
end
