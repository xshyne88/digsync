defmodule Digsync.Accounts.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Digsync.Accounts.User
    entry Digsync.Accounts.Token
    entry Digsync.Accounts.Friendship
    entry Digsync.Accounts.FriendRequest
    entry Digsync.Accounts.Group
    entry Digsync.Accounts.GroupMessage
    entry Digsync.Accounts.GroupMembership
    entry Digsync.Accounts.GroupRequest
    entry Digsync.Accounts.PrivateMessage
    entry Digsync.Accounts.Event
  end
end
