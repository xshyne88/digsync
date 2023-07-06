defmodule Digsync.Accounts.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Digsync.Accounts.User
    entry Digsync.Accounts.Token
    entry Digsync.Accounts.Friendship
  end
end
