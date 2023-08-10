defmodule Digsync.Factory do
  import Digsync.Fixtures.Default.UserInput
  import Digsync.Fixtures.Default.GroupInput

  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.PrivateMessage

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
    actor = get_actor(params, opts)

    Group
    |> Ash.Changeset.for_create(:create, input, actor: actor)
    |> Accounts.create!()
  end

  def build_private_message(params \\ %{}, opts \\ []) do
    actor = get_actor(params, opts)
    recipient = Map.get_lazy(params, "recipient", fn -> random_user_id() end)
    input = Map.merge(%{text: Faker.StarWars.quote(), recipient: recipient}, params)

    PrivateMessage
    |> Ash.Changeset.for_create(:create, input, actor: actor)
    |> Accounts.create!()
  end

  defp random_user_id, do: Map.get(build_user(), :id)

  defp get_actor(params, opts) do
    params["actor"] || opts[:actor] || build_user()
  end
end
