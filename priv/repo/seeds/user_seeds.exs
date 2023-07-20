defmodule UserSeed do
  alias Digsync.Accounts
  alias Digsync.Accounts.User
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.GroupMembership
  alias Digsync.Accounts.GroupRequest
  alias Digsync.FamilyGuy
  alias Digsync.Fixtures.User

  import Digsync.Fixtures.User, only: [build_user: 2]

  require Ash.Query

  def family_guy_seeds do
    data = FamilyGuy.data()

    FamilyGuy.names()
    |> Enum.map(&build_user(data[&1], []))
    |> Enum.each(&log_user/1)

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
      |> Accounts.create!()

    GroupRequest
    |> Ash.Changeset.for_create(:create, %{group: griffins.id}, actor: stewie)
    |> Accounts.create()
    |> case do
      {:ok, result} ->
        IO.inspect(result)

      {:error, error} ->
        IO.inspect(error)

        Enum.map(error.errors, fn err ->
          IO.inspect(Ash.Error.Forbidden.Policy.report(err, help_text?: true))
        end)
    end
    |> IO.inspect(label: "result")
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
  end
end
