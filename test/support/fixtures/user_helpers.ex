defmodule Digsync.UserFixtures.Helpers do
  import Faker.Util

  @supported_types [:seinfeld, :family_guy]

  def default_user_input(type \\ :family_guy) do
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
      bio: bio(type),
      skill_level: Faker.Util.pick(Digsync.Types.SkillLevel.values())
    }

    put_name(attrs, type)
  end

  def put_name(attrs, type) when type in @supported_types do
    type
    |> name()
    |> String.split(" ")
    |> Enum.filter(&(&1 != " "))
    |> parse_name(attrs, type)
  end

  def put_name(attrs, _type) do
    attrs
    |> Map.put(:first_name, Faker.Person.first_name())
    |> Map.put(:last_name, Faker.Person.last_name())
    |> Map.put(:email, Faker.Internet.email())
  end

  def parse_name([single_name], attrs, type) do
    attrs
    |> Map.put(:first_name, single_name)
    |> Map.put(:email, email(single_name, type))
  end

  def parse_name([first, last], attrs, type) do
    attrs
    |> Map.put(:first_name, first)
    |> Map.put(:last_name, last)
    |> Map.put(:email, email(first, type))
  end

  def parse_name([first, middle, last], attrs, type) do
    attrs
    |> Map.put(:first_name, email(first <> " " <> middle, type))
    |> Map.put(:last_name, last)
    |> Map.put(:email, email(first, type))
  end

  def parse_name(_, attrs, _), do: attrs

  def email(name, type) do
    name <> String.slice(Faker.UUID.v4(), -7, 7) <> "@#{type}.com"
  end

  def bio(:seinfled) do
    Faker.Util.pick(Faker.Lorem.sentences(:rand.uniform(3) + 1))
  end

  def bio(:family_guy) do
    pick(family_guy_quotes())
  end

  def name(:seinfeld), do: pick(seinfeld_names())
  def name(:family_guy), do: pick(family_guy_names())

  def seinfeld_names() do
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

  def family_guy_name(), do: pick(family_guy_names())

  def family_guy_names() do
    [
      "Peter Griffin",
      "Lois Griffin",
      "Meg Griffin",
      "Chris Griffin",
      "Stewie Griffin",
      "Brian Griffin",
      "Francis Griffin",
      "Mickey McFinnigan",
      "Thelma Griffin",
      "Karen Griffin",
      "Carter Pewterschmidt",
      "Barabara Pewterschmidt",
      "Glenn Quagmire",
      "Cleveland Brown",
      "Joe Swanson",
      "Bonnie Swanson",
      "Mort Goldman",
      "Tom Tucker",
      "Joyce Kinney",
      "Diane Simmons",
      "Ollie Williams",
      "Tricia Takanawa",
      "Principal Shephard",
      "Mayor Adam West",
      "James Woods",
      "Evil Monkey"
    ]
  end

  def family_guy_quotes() do
    [
      "It’s Peanut Butter Jelly Time.",
      "I’ve got an idea–an idea so smart that my head would explode if I even began to know what I’m talking about.",
      "A degenerate, am I? Well, you are a festisio! See? I can make up words too, sister.",
      "Now I may be an idiot, but there’s one thing I am not sir, and that sir, is an idiot.",
      "Isn’t ‘bribe’ just another word for ‘love’?",
      "I am so not competitive. In fact, I am the least non-competitive. So I win.",
      "Hey, don't try to take this away from me. This is the only thing I've ever been good at. Well, this and timing my farts to a thunderstorm.",
      "Joe, gag on my fat dauber.",
      "People in love can overcome anything.",
      "Amazing. One second of a stranger's voice on a phone, and you've got full Bollywood.",
      "You know, this is great guys. Drinking and eating garbage. I'm glad we all took a mental health day."
    ]
  end
end
