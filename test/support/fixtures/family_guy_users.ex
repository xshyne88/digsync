defmodule Digsync.FamilyGuy do
  require Ash.Query

  @names [
    "Barbara Pewterschmidt",
    "Bonnie Swanson",
    "Brian Griffin",
    "Carter Pewterschmidt",
    "Chris Griffin",
    "Cleveland Brown",
    "Glenn Quagmire",
    "James Woods",
    "Joe Swanson",
    "Joyce Kinney",
    "Lois Griffin",
    "MayorAdam West",
    "Meg Griffin",
    "Mickey McFinnigan",
    "Mort Goldman",
    "Peter Griffin",
    "Principal Shepherd",
    "Stewie Griffin",
    "Tom Tucker",
    "Tricia Takanawa"
  ]
  def names, do: @names

  def data do
    string_data()
    |> Enum.map(fn
      {k, v} when k in @names ->
        {k, Map.new(Enum.map(v, fn {k, v} -> {String.to_atom(k), v} end))}

      {k, v} when is_atom(k) ->
        {k, v}

      {k, v} ->
        {String.to_atom(k), v}
    end)
    |> Map.new()
  end

  def get_user(first_name) do
    Digsync.Accounts.User
    |> Ash.Query.for_read(:by_first, %{first_name: first_name})
    |> Digsync.Accounts.read_one!()
  end

  defmacro create_variables() do
    assignments =
      Enum.map(@names, fn name ->
        [first_name | _] = String.split(name, " ")
        var_name = Macro.var(String.to_atom(String.downcase(first_name)), nil)

        quote do
          unquote(var_name) = apply(&Digsync.FamilyGuy.get_user/1, [unquote(first_name)])
        end
      end)

    quote do
      (unquote_splicing(assignments))
    end
  end

  def string_data do
    %{
      "Peter Griffin" => %{
        "email" => "peter@pawtucketpatriotbrewery.com",
        "facebook_link" => "petergriffin@facebook.com",
        "instagram_link" => "pgriffin@instagram.com",
        "linkedin_link" => "peter-griffin-82@linkedin.com",
        "github_link" => "peter_griffin@github.com",
        "gender" => :male,
        "age" => 43,
        "bio" => "Lois, if I'm not back in five minutes... wait longer!",
        "skill_level" => :BB,
        "first_name" => "Peter",
        "last_name" => "Griffin"
      },
      "Lois Griffin" => %{
        "email" => "lois@quahogcityhall.com",
        "facebook_link" => "loisgriffin@facebook.com",
        "instagram_link" => "lgriffin@instagram.com",
        "linkedin_link" => "lois-griffin@linkedin.com",
        "github_link" => "lois_griffin@github.com",
        "gender" => :female,
        "age" => 40,
        "bio" =>
          "Why are you all staring? Haven't you ever seen a woman in bed with a dog before?",
        "skill_level" => :B,
        "first_name" => "Lois",
        "last_name" => "Griffin"
      },
      "Meg Griffin" => %{
        "email" => "meg@quahoghighschool.com",
        "facebook_link" => "meggriffin@facebook.com",
        "instagram_link" => "mgriffin@instagram.com",
        "linkedin_link" => "meg-griffin@linkedin.com",
        "github_link" => "meg_griffin@github.com",
        "gender" => :female,
        "age" => 16,
        "bio" => "I'm a loser, I'm a hater. I have a crush on Mayor Adam West.",
        "skill_level" => :C,
        "first_name" => "Meg",
        "last_name" => "Griffin"
      },
      "Chris Griffin" => %{
        "email" => "chris@quahoghighschool.com",
        "facebook_link" => "chrisgriffin@facebook.com",
        "instagram_link" => "cgriffin@instagram.com",
        "linkedin_link" => "chris-griffin@linkedin.com",
        "github_link" => "chris_griffin@github.com",
        "gender" => :male,
        "age" => 14,
        "bio" => "Hey, did somebody order some love?",
        "skill_level" => :B,
        "first_name" => "Chris",
        "last_name" => "Griffin"
      },
      "Stewie Griffin" => %{
        "email" => "stewie@gotobed.com",
        "facebook_link" => "stewiegriffin@facebook.com",
        "instagram_link" => "sgriffin@instagram.com",
        "linkedin_link" => "stewie-griffin@linkedin.com",
        "github_link" => "stewie_griffin@github.com",
        "gender" => :male,
        "age" => 1,
        "bio" => "Victory is mine!",
        "skill_level" => :A,
        "first_name" => "Stewie",
        "last_name" => "Griffin"
      },
      "Brian Griffin" => %{
        "email" => "brian@quahoglibrary.com",
        "facebook_link" => "briangriffin@facebook.com",
        "instagram_link" => "bgriffin@instagram.com",
        "linkedin_link" => "brian-griffin@linkedin.com",
        "github_link" => "brian_griffin@github.com",
        "gender" => :male,
        "age" => 8,
        "bio" => "You know, I'm a dog. I'm not your best friend. I don't even like you.",
        "skill_level" => :B,
        "first_name" => "Brian",
        "last_name" => "Griffin"
      },
      "Mickey McFinnigan" => %{
        "email" => "mickey@quahogbar.com",
        "facebook_link" => "mickeymcfinnigan@facebook.com",
        "instagram_link" => "mmcfinnigan@instagram.com",
        "linkedin_link" => "mickey-mcfinnigan@linkedin.com",
        "github_link" => "mickey_mcfinnigan@github.com",
        "gender" => :male,
        "age" => 50,
        "bio" => "This place is worse than that bar in Philadelphia.",
        "skill_level" => :C,
        "first_name" => "Mickey",
        "last_name" => "McFinnigan"
      },
      "Carter Pewterschmidt" => %{
        "email" => "carter@pewterschmidtenterprises.com",
        "facebook_link" => "carterpewterschmidt@facebook.com",
        "instagram_link" => "cpewterschmidt@instagram.com",
        "linkedin_link" => "carter-pewterschmidt@linkedin.com",
        "github_link" => "carter_pewterschmidt@github.com",
        "gender" => :male,
        "age" => 75,
        "bio" =>
          "You know, Griffin, if I'm not mistaken, this might be the first time I've ever actually heard you say something that made sense.",
        "skill_level" => :A,
        "first_name" => "Carter",
        "last_name" => "Pewterschmidt"
      },
      "Barbara Pewterschmidt" => %{
        "email" => "barbara@pewterschmidtenterprises.com",
        "facebook_link" => "barbarapewterschmidt@facebook.com",
        "instagram_link" => "bpewterschmidt@instagram.com",
        "linkedin_link" => "barbara-pewterschmidt@linkedin.com",
        "github_link" => "barbara_pewterschmidt@github.com",
        "gender" => :female,
        "age" => 70,
        "bio" =>
          "I'm going to return to my home planet now. Goodbye, Lois. Goodbye, Peter. Chris, Meg, Stewie, Brian.",
        "skill_level" => :BB,
        "first_name" => "Barbara",
        "last_name" => "Pewterschmidt"
      },
      "Glenn Quagmire" => %{
        "email" => "quagmire@quahog.com",
        "facebook_link" => "glennquagmire@facebook.com",
        "instagram_link" => "gquagmire@instagram.com",
        "linkedin_link" => "glenn-quagmire@linkedin.com",
        "github_link" => "glenn_quagmire@github.com",
        "gender" => :male,
        "age" => 41,
        "bio" => "Giggity giggity goo!",
        "skill_level" => :AA,
        "first_name" => "Glenn",
        "last_name" => "Quagmire"
      },
      "Cleveland Brown" => %{
        "email" => "cleveland@stoolbend.com",
        "facebook_link" => "clevelandbrown@facebook.com",
        "instagram_link" => "cbrown@instagram.com",
        "linkedin_link" => "cleveland-brown@linkedin.com",
        "github_link" => "cleveland_brown@github.com",
        "gender" => :male,
        "age" => 45,
        "bio" => "That's nasty!",
        "skill_level" => :B,
        "first_name" => "Cleveland",
        "last_name" => "Brown"
      },
      "Joe Swanson" => %{
        "email" => "joe@quahogpolice.com",
        "facebook_link" => "joeswanson@facebook.com",
        "instagram_link" => "jswanson@instagram.com",
        "linkedin_link" => "joe-swanson@linkedin.com",
        "github_link" => "joe_swanson@github.com",
        "gender" => :male,
        "age" => 42,
        "bio" => "Alright, let's go kick some ass!",
        "skill_level" => :AA,
        "first_name" => "Joe",
        "last_name" => "Swanson"
      },
      "Bonnie Swanson" => %{
        "email" => "bonnie@quahog.com",
        "facebook_link" => "bonnieswanson@facebook.com",
        "instagram_link" => "bswanson@instagram.com",
        "linkedin_link" => "bonnie-swanson@linkedin.com",
        "github_link" => "bonnie_swanson@github.com",
        "gender" => :female,
        "age" => 39,
        "bio" => "I don't know, Joe. Maybe there's a reason I don't like to have sex anymore.",
        "skill_level" => :BB,
        "first_name" => "Bonnie",
        "last_name" => "Swanson"
      },
      "Mort Goldman" => %{
        "email" => "mort@goldmanspharmacy.com",
        "facebook_link" => "mortgoldman@facebook.com",
        "instagram_link" => "mgoldman@instagram.com",
        "linkedin_link" => "mort-goldman@linkedin.com",
        "github_link" => "mort_goldman@github.com",
        "gender" => :male,
        "age" => 55,
        "bio" => "I'm Mort Goldman. I own Goldman's Pharmacy on Spooner Street.",
        "skill_level" => :C,
        "first_name" => "Mort",
        "last_name" => "Goldman"
      },
      "Tom Tucker" => %{
        "email" => "tom@quahognews.com",
        "facebook_link" => "tomtucker@facebook.com",
        "instagram_link" => "ttucker@instagram.com",
        "linkedin_link" => "tom-tucker@linkedin.com",
        "github_link" => "tom_tucker@github.com",
        "gender" => :male,
        "age" => 50,
        "bio" => "And I'm Tom Tucker. Coming up, Quahog goes bananas.",
        "skill_level" => :BB,
        "first_name" => "Tom",
        "last_name" => "Tucker"
      },
      "Joyce Kinney" => %{
        "email" => "joyce@quahognews.com",
        "facebook_link" => "joycekinney@facebook.com",
        "instagram_link" => "jkinney@instagram.com",
        "linkedin_link" => "joyce-kinney@linkedin.com",
        "github_link" => "joyce_kinney@github.com",
        "gender" => :female,
        "age" => 35,
        "bio" =>
          "Joyce Kinney here, and I think it's time we start holding people accountable for their actions.",
        "skill_level" => :BB,
        "first_name" => "Joyce",
        "last_name" => "Kinney"
      },
      "Tricia Takanawa" => %{
        "email" => "tricia@quahognews.com",
        "facebook_link" => "triciatakanawa@facebook.com",
        "instagram_link" => "ttakanawa@instagram.com",
        "linkedin_link" => "tricia-takanawa@linkedin.com",
        "github_link" => "tricia_takanawa@github.com",
        "gender" => :female,
        "age" => 40,
        "bio" => "Tricia Takanawa reporting from outside the Quahog City Hall.",
        "skill_level" => :BB,
        "first_name" => "Tricia",
        "last_name" => "Takanawa"
      },
      "Principal Shepherd" => %{
        "email" => "principal@jameswoods.com",
        "facebook_link" => "principalshepherd@facebook.com",
        "instagram_link" => "pshepherd@instagram.com",
        "linkedin_link" => "principal-shepherd@linkedin.com",
        "github_link" => "principal_shepherd@github.com",
        "gender" => :male,
        "age" => 50,
        "bio" =>
          "Good morning, Quahog High School. This is Principal Shepherd. I'm joined by James Woods. We'd like to apologize for last night's announcement.",
        "skill_level" => :BB,
        "first_name" => "Principal",
        "last_name" => "Shepherd"
      },
      "MayorAdam West" => %{
        "email" => "adam@quahogcityhall.com",
        "facebook_link" => "adamwest@facebook.com",
        "instagram_link" => "awest@instagram.com",
        "linkedin_link" => "adam-west@linkedin.com",
        "github_link" => "adam_west@github.com",
        "gender" => :male,
        "age" => 60,
        "bio" => "I'm Mayor Adam West, and I approve this message.",
        "skill_level" => :BB,
        "first_name" => "Adam",
        "last_name" => "West"
      },
      "James Woods" => %{
        "email" => "james@hollywood.com",
        "facebook_link" => "jameswoods@facebook.com",
        "instagram_link" => "jwoods@instagram.com",
        "linkedin_link" => "james-woods@linkedin.com",
        "github_link" => "james_woods@github.com",
        "gender" => :male,
        "age" => 65,
        "bio" =>
          "Hi, I'm James Woods. You might remember me from such films as 'Hercules' and 'Casino.'",
        "skill_level" => :BB,
        "first_name" => "James",
        "last_name" => "Woods"
      }
    }
  end
end
