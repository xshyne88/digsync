defmodule Digsync.Seinfeld do
  def names() do
    [
      "George Costanza",
      "Kramer Kramer",
      "Elaine Benes",
      "Newman Newman",
      "Jerry Seinfeld",
      "Frank Costanza",
      "J Peterman",
      "Uncle Leo",
      "David Puddy"
    ]
  end

  def data() do
    %{
      "George Costanza" => %{
        email: "george@vandelayindustries.com",
        facebook_link: "georgecostanza@facebook.com",
        instagram_link: "gcostanza@instagram.com",
        linkedin_link: "george-costanza@linkedin.com",
        github_link: "george_costanza@github.com",
        gender: :male,
        age: 45,
        bio: "I'm George. I'm unemployed and I live with my parents.",
        skill_level: :B,
        first_name: "George",
        last_name: "Costanza"
      },
      "Kramer Kramer" => %{
        email: "kramer@hennigans.com",
        facebook_link: "kramerkramer@facebook.com",
        instagram_link: "kkramer@instagram.com",
        linkedin_link: "kramer-kramer@linkedin.com",
        github_link: "kramer_kramer@github.com",
        gender: :male,
        age: 40,
        bio: "I'm Kramer. I'm an entrepreneur, but my ideas are a bit unconventional.",
        skill_level: :C,
        first_name: "Kramer",
        last_name: "Kramer"
      },
      "Elaine Benes" => %{
        email: "elaine@dalmatian.com",
        facebook_link: "elainebenes@facebook.com",
        instagram_link: "ebenes@instagram.com",
        linkedin_link: "elaine-benes@linkedin.com",
        github_link: "elaine_benes@github.com",
        gender: :female,
        age: 38,
        bio: "I'm Elaine. I work at Pendant Publishing and I have a knack for bad boyfriends.",
        skill_level: :A,
        first_name: "Elaine",
        last_name: "Benes"
      },
      "Newman Newman" => %{
        email: "newman@usps.com",
        facebook_link: "newmannewman@facebook.com",
        instagram_link: "nnewman@instagram.com",
        linkedin_link: "newman-newman@linkedin.com",
        github_link: "newman_newman@github.com",
        gender: :male,
        age: 50,
        bio: "Hello, Jerry. Newman is here!",
        skill_level: :C,
        first_name: "Newman",
        last_name: "Newman"
      },
      "Jerry Seinfeld" => %{
        email: "jerry@jerrystandup.com",
        facebook_link: "jerryseinfeld@facebook.com",
        instagram_link: "jseinfeld@instagram.com",
        linkedin_link: "jerry-seinfeld@linkedin.com",
        github_link: "jerry_seinfeld@github.com",
        gender: :male,
        age: 45,
        bio: "I'm Jerry. I'm a stand-up comedian and nothing seems to faze me.",
        skill_level: :AA,
        first_name: "Jerry",
        last_name: "Seinfeld"
      },
      "Frank Costanza" => %{
        email: "frank@serenitynow.com",
        facebook_link: "frankcostanza@facebook.com",
        instagram_link: "fcostanza@instagram.com",
        linkedin_link: "frank-costanza@linkedin.com",
        github_link: "frank_costanza@github.com",
        gender: :male,
        age: 65,
        bio: "Serenity now!",
        skill_level: :B,
        first_name: "Frank",
        last_name: "Costanza"
      },
      "J Peterman" => %{
        email: "jpeterman@jppeterman.com",
        facebook_link: "jpeterman@facebook.com",
        instagram_link: "jpeterman@instagram.com",
        linkedin_link: "j-peterman@linkedin.com",
        github_link: "jpeterman@github.com",
        gender: :male,
        age: 60,
        bio: "I'm J. Peterman, the catalog king!",
        skill_level: :A,
        first_name: "J",
        last_name: "Peterman"
      },
      "Uncle Leo" => %{
        email: "uncleleo@seinfeld.com",
        facebook_link: "uncleleo@facebook.com",
        instagram_link: "uleo@instagram.com",
        linkedin_link: "uncle-leo@linkedin.com",
        github_link: "uncle_leo@github.com",
        gender: :male,
        age: 70,
        bio: "Hello, Jerry! It's Uncle Leo!",
        skill_level: :C,
        first_name: "Uncle",
        last_name: "Leo"
      },
      "David Puddy" => %{
        email: "david@arclight.com",
        facebook_link: "davidpuddy@facebook.com",
        instagram_link: "dpuddy@instagram.com",
        linkedin_link: "david-puddy@linkedin.com",
        github_link: "david_puddy@github.com",
        gender: :male,
        age: 40,
        bio: "I'm Puddy. I'm a car salesman and a loyal New Jersey Devils fan.",
        skill_level: :B,
        first_name: "David",
        last_name: "Puddy"
      }
    }
  end
end
