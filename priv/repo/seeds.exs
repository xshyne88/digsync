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

user_seeds_path = Path.join([__DIR__, "/seeds/user_seeds.exs"])
Code.require_file(user_seeds_path)

defmodule Seeding do
  require Logger

  def begin do
    UserSeed.family_guy_seeds()
  end
end

Seeding.begin()
