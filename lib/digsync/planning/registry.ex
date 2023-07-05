defmodule Digsync.Planning.Registry do
  use Ash.Registry, extensions: [Ash.Registry.ResourceValidations]

  entries do
    entry Digsync.Planning.Event
  end
end
