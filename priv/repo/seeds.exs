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
defmodule Seed do
  defp take_one(list) do
    list
    |> Enum.shuffle()
    |> Enum.take(1)
    |> List.first()
  end

  defp user_attrs do
    character = Faker.StarWars.character()

    attrs = %{
      # password: asdfasdf
      hashed_password: "$2b$12$TZr.nM9lYj7W/f.A11LQ0Oe.gjKr8R65gY5CW8r1RjNZ5h4rD7anm",
      phone_number: Faker.Phone.EnUs.phone(),
      email: Faker.Internet.email(),
      type: :user,
      create_type: :system,
      facebook_link: Faker.Internet.url(),
      instagram_link: Faker.Internet.url(),
      linkedin_link: Faker.Internet.url(),
      github_link: Faker.Internet.url(),
      gender: :male,
      age: :rand.uniform(40) + 16,
      bio: take_one(Faker.Lorem.sentences(:rand.uniform(3) + 1)),
      skill_level: take_one(Digsync.Types.SkillLevel.values())
    }

    character_list =
      character
      |> String.split(" ")
      |> Enum.filter(&(&1 == " "))
      |> case do
        [name] ->
          attrs
          |> Map.put(:first_name, name)
          |> Map.put(:last_name, Faker.StarWars.character())

        [first_name, last_name] ->
          attrs
          |> Map.put(:first_name, first_name)
          |> Map.put(:last_name, last_name)

        _ ->
          attrs
          |> Map.put(:first_name, Faker.StarWars.character())
          |> Map.put(:last_name, Faker.StarWars.character())
      end
  end

  def start do
    for _ <- 1..10 do
      Digsync.Accounts.User
      |> Ash.Changeset.for_create(:create, user_attrs())
      |> Digsync.Accounts.create!()
    end
  end
end

Seed.start()
