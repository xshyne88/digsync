defmodule Digsync.Fixtures.Default.GroupInput do
  def default_group_input() do
    %{
      name: Faker.Company.name(),
      description: Faker.Company.bullshit(),
      invite_only?: false,
      location: "#{Faker.Address.latitude()} , #{Faker.Address.longitude()}",
      preferred_location: "location",
      type: Faker.Util.pick(Digsync.Types.GroupType.values())
    }
  end
end
