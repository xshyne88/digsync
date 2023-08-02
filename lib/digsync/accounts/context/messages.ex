defmodule Digsync.Accounts.Messages do
  alias Digsync.Accounts
  alias Digsync.Accounts.Message

  @type opts :: any() | [actor: Digsync.Accounts.User.t()]

  def create(%{text: text}, opts \\ []) do
    Message
    |> Ash.Changeset.for_create(:create, %{text: text}, actor: opts[:actor])
    |> Accounts.create()
  end
end
