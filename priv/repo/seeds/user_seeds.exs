defmodule UserSeed do
  alias Digsync.FamilyGuy
  alias Digsync.UserFixtures

  import Digsync.UserFixtures, only: [build_user: 2]

  def family_guy_seeds do
    data = FamilyGuy.data()

    FamilyGuy.names()
    |> Enum.map(build_user(data[&1]))
    |> Enum.each(&log_user/1)
  end

  def developer_users do
    %{}
    |> Map.put(:first_name, "Chase")
    |> Map.put(:last_name, "Philips")
    |> Map.put(:email, "chasehomedecor@gmail.com")
    |> Map.put(:address, "1100 3rd Ave N, Nasheville, TN 37208")
    |> build_user()
  end

  defp log_user(user) do
    require Logger

    Logger.info("Created user: #{user.first_name} #{user.last_name} - #{user.email}")
  end
end
