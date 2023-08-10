defmodule Digsync.Factory do
  import Digsync.Fixtures.Default.UserInput
  import Digsync.Fixtures.Default.GroupInput

  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.Group

  def build_actor(params \\ %{}, _opts \\ []) do
    Ash.set_actor(build_user(Map.merge(params, %{user_type: :admin})))
  end

  def build_user(params \\ %{}, _opts \\ []) do
    input = Map.merge(default_user_input(), params)

    User
    |> Ash.Changeset.for_create(:create, input)
    |> Accounts.create!()
  end

  def build_group(params \\ %{}, opts \\ []) do
    input = Map.merge(default_group_input(), params)
    actor = params["actor"] || opts[:actor] || build_user()

    Group
    |> Ash.Changeset.for_create(:create, input, actor: actor)
    |> Accounts.create!()
  end
end
