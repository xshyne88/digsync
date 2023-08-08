defmodule Digsync.Accounts.GroupsTest do
  use Digsync.DataCase, async: true

  import Digsync.Fixtures.User

  alias Digsync.Accounts.Group
  alias Digsync.Accounts.Groups

  describe "get_by_id/3" do
    test "returns a group by id" do
      actor = build_user()
      group = build_group(actor)

      result = Groups.get_by_id(group.id, actor)

      assert result.id == group.id
    end

    test "loads relationships when fetching by id" do
      actor = build_user()
      group = build_group(actor)

      result = Groups.get_by_id(group.id, actor, [:creator])

      assert result.creator.id == actor.id
      assert result.creator.email == actor.email
    end
  end

  describe "all_groups/3" do
    test "fetches all groups" do
      actor = build_user()
      group1 = build_group(actor)
      group2 = build_group(actor)

      {:ok, result} = Groups.all_groups(actor)

      ids = Enum.map(result, & &1.id)
      assert Enum.count(ids) == 2
      assert group1.id in ids
      assert group2.id in ids
    end

    test "fetches all groups and their relationships" do
      actor = build_user()
      actor2 = build_user()
      build_group(actor)
      build_group(actor2)

      {:ok, result} = Groups.all_groups(actor, [:creator])

      emails = Enum.map(result, & &1.creator.email)
      assert Enum.count(emails) == 2
      assert actor.email in emails
      assert actor2.email in emails
    end
  end

  defp build_group(actor) do
    Group
    |> Ash.Changeset.for_create(
      :create,
      %{name: Faker.Company.bullshit(), description: Faker.Company.bullshit()},
      actor: actor
    )
    |> Accounts.create!()
  end
end
