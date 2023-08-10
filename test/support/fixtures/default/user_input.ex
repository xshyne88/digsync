defmodule Digsync.Fixtures.Default.UserInput do
  import Faker.Util

  def default_user_input(input \\ %{}) do
    name = input["name"] || "#{Faker.Person.first_name()} #{Faker.Person.last_name()}"

    attrs = %{
      # password: asdfasdf
      hashed_password: "$2b$12$TZr.nM9lYj7W/f.A11LQ0Oe.gjKr8R65gY5CW8r1RjNZ5h4rD7anm",
      phone_number: Faker.Phone.EnUs.phone(),
      email: Faker.Internet.email(),
      create_type: :system,
      facebook_link: Faker.Internet.url(),
      instagram_link: Faker.Internet.url(),
      linkedin_link: Faker.Internet.url(),
      github_link: Faker.Internet.url(),
      gender: pick(Digsync.Types.Gender.values()),
      age: :rand.uniform(40) + 18,
      bio: "Biography about #{name}",
      skill_level: Faker.Util.pick(Digsync.Types.SkillLevel.values())
    }

    put_name(name, attrs)
  end

  def put_name(name, attrs) do
    name
    |> String.split(" ")
    |> Enum.filter(&(&1 != " "))
    |> parse_name(attrs)
  end

  def parse_name([single_name], attrs) do
    attrs
    |> Map.put(:first_name, single_name)
    |> Map.put(:email, email(single_name))
  end

  def parse_name([first, last], attrs) do
    attrs
    |> Map.put(:first_name, first)
    |> Map.put(:last_name, last)
    |> Map.put(:email, email(first))
  end

  def parse_name([first, middle, last], attrs) do
    attrs
    |> Map.put(:first_name, email(first <> " " <> middle))
    |> Map.put(:last_name, last)
    |> Map.put(:email, email(first))
  end

  def parse_name(_, attrs, _), do: attrs

  def email(name) do
    name <> String.slice(Faker.UUID.v4(), -7, 7) <> "@#{name}.com"
  end
end
