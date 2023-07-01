defmodule Digsync.Accounts do
  use Ash.Api

  resources do
    registry Digsync.Accounts.Registry
  end
end
