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

user_seeds_path = Path.join([__DIR__, "user_seeds.exs"])
Code.require_file(user_seeds_path)

defmodule Seed do
  require Logger

  def start do
    users =
      Enum.map(1..10, fn _ ->
        Digsync.Accounts.User
        |> Ash.Changeset.for_create(:create, UserSeed.default_user_input(:seinfeld))
        |> Digsync.Accounts.create!()
      end)

    admin =
      Digsync.Accounts.User
      |> Ash.Changeset.for_create(:create, UserSeed.default_user())
      |> Digsync.Accounts.create!()

    Enum.each(users, fn user ->
      Logger.info("Created User: #{user.first_name} #{user.last_name} - #{user.email}")
    end)

    Logger.info("Created Actor Admin: #{admin.first_name} #{admin.last_name} - #{admin.email}")
  end
end

Seed.start()
