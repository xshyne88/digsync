defmodule Digsync.UserFixtures do
  import Digsync.UserFixtures.Helpers

  alias Digsync.Accounts
  alias Digsync.Accounts.User

  def build_actor(params \\ %{}, _opts \\ []) do
    Ash.set_actor(build_user(Map.merge(params, %{user_type: :admin})))
  end

  def build_user(params \\ %{}, _opts \\ []) do
    input = Map.merge(default_user_input(), params)

    User
    |> Ash.Changeset.for_create(:create, input)
    |> Accounts.create!()
  end
end
