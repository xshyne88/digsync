alias Digsync.Geo.Helpers
alias Digsync.Planning.Event
alias Digsync.GeoCensus.Client
alias Digsync.Accounts.User
alias Digsync.Accounts.Group
alias Digsync.Accounts.Message
alias Digsync.Accounts.Messages
alias Digsync.Accounts.PrivateMessage
alias Digsync.Accounts.GroupMembership
alias Digsync.Accounts.GroupMessage
alias Digsync.Accounts.Token
alias Digsync.Accounts.Friendship
alias Digsync.Accounts.FriendRequest
alias Digsync.Accounts
alias Digsync.Accounts.Flows.CreateFriendship

require Ash.Query
require Logger

defmodule Console do
  def actor, do: Ash.get_actor()

  def get_admin_user do
    User
    |> Ash.Query.filter(email == "chasehomedecor@gmail.com")
    |> Ash.Query.limit(1)
    |> Accounts.read_one!()
  end

  def set_actor do
    Ash.set_actor(get_admin_user())
  end

  def get_ids do
    Ash.Query.for_read(User, :read)
    |> Ash.Query.select([:id, :email], replace?: true)
    |> Accounts.read!()
    |> Enum.map(&{&1.id, to_string(&1.email)})
  end

  def get_random_id do
    {id, email} =
      get_ids()
      |> Enum.shuffle()
      |> Enum.take(1)
      |> List.first()

    Logger.info("Getting ID for email: #{email}")
    id
  end
end

Console.set_actor()
