# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Digsync.Repo.insert!(%Digsync.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# user_seeds_path = Path.join([__DIR__, "/seeds/user_seeds.exs"])
# Code.require_file(user_seeds_path)

# defmodule Seed do
#   require Logger
#   # require YamlElixir

#   def start do
#     users =
#       Enum.map(1..10, fn _ ->
#         Digsync.Accounts.User
#         |> Ash.Changeset.for_create(:create, UserSeed.default_user_input(:seinfeld))
#         |> Digsync.Accounts.create!()
#       end)

#     admin =
#       Digsync.Accounts.User
#       |> Ash.Changeset.for_create(:create, UserSeed.default_user())
#       |> Digsync.Accounts.create!()

#     group =
#       Digsync.Accounts.Group
#       |> Ash.Changeset.for_create(:create, %{name: "Family Guy", description: "The Griffins"},
#         actor: admin
#       )
#       |> Digsync.Accounts.create!()

#     Logger.info("Created Group: #{group.name}")

#     # group_membership =
#     Digsync.Accounts.GroupMembership
#     |> Ash.Changeset.for_create(:actor_to_group, %{group: group.id}, actor: admin)
#     |> Digsync.Accounts.create!()

#     Logger.info("Added #{admin.id} to Group: #{group.id}")

#     Enum.each(users, fn user ->
#       Logger.info("Created User: #{user.first_name} #{user.last_name} - #{user.email}")
#     end)

#     Logger.info("Created Actor Admin: #{admin.first_name} #{admin.last_name} - #{admin.email}")
#   end
# end

# user_seeds_path = Path.join([__DIR__, "/test/support/fixtures/user.ex"])
# Code.require_file(user_seeds_path)

# def default_user do
#   attrs = default_user_input(:default)

#   attrs
#   |> Map.put(:first_name, "Chase")
#   |> Map.put(:last_name, "Philips")
#   |> Map.put(:email, "chasehomedecor@gmail.com")
#   |> Map.put(:address, "1100 3rd Ave N, Nasheville, TN 37208")
# end

user_seeds_path = Path.join([__DIR__, "/seeds/user_seeds.exs"])
Code.require_file(user_seeds_path)

defmodule Test do
  require Logger

  def start do
    UserSeed.family_guy_seeds()
  end
end

Test.start()

# Seed.start()
