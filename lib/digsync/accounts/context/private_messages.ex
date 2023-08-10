defmodule Digsync.Accounts.PrivateMessages do
  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.PrivateMessage

  @spec create(String.t(), String.t(), User.t()) ::
          {:error, any} | {:ok, struct} | {:ok, struct, [Ash.Notifier.Notification.t()]}
  def create(recipient_id, text, actor) do
    params = %{
      text: text,
      recipient: recipient_id
    }

    PrivateMessage
    |> Ash.Changeset.for_create(:create, params, actor: actor)
    |> Accounts.create()
  end
end
