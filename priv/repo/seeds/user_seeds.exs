defmodule UserSeed do
  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.GroupMembership
  alias Digsync.Accounts.GroupRequest
  alias Digsync.FamilyGuy

  import Digsync.Fixtures.User, only: [build_user: 2]

  require Ash.Query

  def family_guy_seeds do
    data = FamilyGuy.data()

    family_guy_users =
      FamilyGuy.names()
      |> Enum.map(&build_user(data[&1], []))
      |> Enum.map(&log_user/1)

    peter =
      User
      |> Ash.Query.for_read(:by_first_and_last, %{first_name: "Peter", last_name: "Griffin"})
      |> Accounts.read_one!()

    stewie =
      User
      |> Ash.Query.for_read(:by_first_and_last, %{first_name: "Stewie", last_name: "Griffin"})
      |> Accounts.read_one!()

    griffins =
      Group
      |> Ash.Changeset.for_create(
        :create,
        %{name: "The Griffins", description: "Quahog's finest"},
        actor: peter
      )
      |> Accounts.create!(authorize?: false)

    developer_users()

    GroupRequest
    |> Ash.Changeset.for_create(:create, %{group: griffins.id}, actor: stewie)
    |> Accounts.create(authorize?: false)

    family_guy_users
    |> Enum.filter(&(&1.id != peter.id))
    |> Enum.map(fn
      fg ->
        GroupMembership
        |> Ash.Changeset.for_create(:seed_create, %{group: griffins.id}, actor: fg)
        |> Accounts.create!(authorize?: false)
    end)
  end

  def developer_users do
    %{}
    |> Map.put(:first_name, "Chase")
    |> Map.put(:last_name, "Philips")
    |> Map.put(:email, "chasehomedecor@gmail.com")
    |> Map.put(:address, "1100 3rd Ave N, Nasheville, TN 37208")
    |> build_user([])
  end

  defp log_user(user) do
    require Logger

    Logger.info("Created user: #{user.first_name} #{user.last_name} - #{user.email}")
    user
  end
end
