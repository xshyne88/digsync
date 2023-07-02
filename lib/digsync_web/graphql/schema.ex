defmodule DigsyncWeb.Schema do
  use Absinthe.Schema

  @apis [Digsync.Accounts]

  use AshGraphql, apis: @apis

  # The query and mutation blocks is where you can add custom absinthe code
  query do
  end

  mutation do
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end
end
