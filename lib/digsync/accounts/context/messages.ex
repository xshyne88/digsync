defmodule Digsync.Accounts.Messages do
  alias Digsync.Accounts
  alias Digsync.Accounts.Message

  def create(text, actor) do
    Message
    |> Ash.Changeset.for_create(:create, %{text: text}, actor: actor)
    |> Accounts.create()
  end
end
