defmodule Digsync.Accounts.PrivateMessages do
  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.PrivateMessage

  @spec create(String.t(), String.t(), User.t()) ::
          {:error, any} | {:ok, struct} | {:ok, struct, [Ash.Notifier.Notification.t()]}
  def create(recipient_id, message_text, actor) do
    params = %{
      message_text: message_text,
      recipient: recipient_id
    }

    PrivateMessage
    |> Ash.Changeset.for_create(:create, params, actor: actor)
    |> Accounts.create()
  end

  def most_recent(actor) do
    PrivateMessage
    |> Ash.Query.load(:message)
    |> Ash.Query.sort()
  end
end
