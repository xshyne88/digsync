defmodule UserSeed do
  def default_user_input(type \\ :seinfeld) do
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
      age: :rand.uniform(40) + 18,
      bio: Faker.Util.pick(Faker.Lorem.sentences(:rand.uniform(3) + 1)),
      skill_level: Faker.Util.pick(Digsync.Types.SkillLevel.values())
    }

    put_name(attrs, type)
  end

  defp put_name(attrs, :starwars) do
    character = Faker.StarWars.character()

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

  defp put_name(attrs, :seinfeld) do
    seinfeld_names()
    |> Faker.Util.pick()
    |> String.split(" ")
    |> Enum.filter(&(&1 != " "))
    |> case do
      [name] ->
        attrs
        |> Map.put(:first_name, name)
        |> Map.put(:email, seinfeld_email(name))

      [first, last] ->
        attrs
        |> Map.put(:first_name, first)
        |> Map.put(:last_name, last)
        |> Map.put(:email, seinfeld_email(first))

      [first, middle, last] ->
        attrs
        |> Map.put(:first_name, first <> " " <> middle)
        |> Map.put(:last_name, last)
        |> Map.put(:email, seinfeld_email(first))

      _ ->
        attrs
    end
  end

  defp seinfeld_email(name), do: name <> String.slice(Faker.UUID.v4(), -7, 7) <> "@seinfeld.com"

  defp seinfeld_names() do
    [
      "George Costanza",
      "Kramer",
      "Elaine Benes",
      "Newman",
      "Jerry Seinfeld",
      "Frank Costanza",
      "Morty Seinfeld",
      "Estelle Costanza",
      "Susan Ross",
      "Helen Seinfeld",
      "J Peterman",
      "Uncle Leo",
      "David Puddy",
      "Justin Pitt",
      "Kenny Bania",
      "Crazy Joe Davola",
      "Jackie Chiles",
      "Jack Klompus",
      "Ruthie Cohen",
      "Tim Whatley",
      "Sue Ellen Mischke",
      "Bob Sacamano",
      "Babs Kramer",
      "Babu Bhatt",
      "George Steinbrenner",
      "Mickey Abbott",
      "Mr. Lippman",
      "Mr. Wilhelm",
      "Russell Dalrymple"
    ]
  end
end
