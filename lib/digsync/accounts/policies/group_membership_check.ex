defmodule Digsync.Accounts.Policies.GroupMembershipCheck do
  use Ash.Policy.FilterCheck

  require Ash.Query

  import Ash.Filter.TemplateHelpers, only: [actor: 1]

  def filter(_opts) do
  end
end
