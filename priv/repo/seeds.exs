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

defmodule Seed do
  require Logger
  require YamlElixir

  def start do
    users =
      Enum.map(1..10, fn _ ->
        Digsync.Accounts.User
        |> Ash.Changeset.for_create(:create, UserSeed.default_user_input(:seinfeld))
        |> Digsync.Accounts.create!()
      end)

    admin =
      Digsync.Accounts.User
      |> Ash.Changeset.for_create(:create, UserSeed.default_user())
      |> Digsync.Accounts.create!()

    group =
      Digsync.Accounts.Group
      |> Ash.Changeset.for_create(:create, %{name: "Family Guy", description: "The Griffins"},
        actor: admin
      )
      |> Digsync.Accounts.create!()

    Logger.info("Created Group: #{group.name}")

    # group_membership =
    Digsync.Accounts.GroupMembership
    |> Ash.Changeset.for_create(:actor_to_group, %{group: group.id}, actor: admin)
    |> Digsync.Accounts.create!()

    Logger.info("Added #{admin.id} to Group: #{group.id}")

    Enum.each(users, fn user ->
      Logger.info("Created User: #{user.first_name} #{user.last_name} - #{user.email}")
    end)

    Logger.info("Created Actor Admin: #{admin.first_name} #{admin.last_name} - #{admin.email}")
  end
end

# defmodule YamlLoader do
#   require YamlElixir

#   defmacro __using__(opts \\ []) do
#     path = Keyword.get(opts, :path)
#     yaml_data = YamlElixir.read_from_file!(path)["en"]["faker"]["family_guy"]

#     module_declaration = generate_module_declaration(yaml_data, __CALLER__.module)
#     function_declarations = generate_function_declarations(yaml_data)

#     quote do
#       unquote(module_declaration)
#       unquote(function_declarations)
#     end
#   end

#   defp generate_module_declaration(yaml_data, calling_module) do
#     module_name = Module.concat(calling_module, :FamilyGuy) |> IO.inspect()

#     quote do
#       defmodule unquote(module_name) do
#         unquote(generate_function_declarations(yaml_data))
#       end
#     end
#   end

#   defp generate_function_declarations(yaml_data) do
#     Enum.map(yaml_data, fn {function_name, values} ->
#       function_name_atom = String.to_atom(to_string(function_name))

#       quote do
#         def unquote(function_name_atom)() do
#           Enum.random(unquote(values))
#         end
#       end
#     end)
#   end
# end

# defmodule MyApp do
#   use YamlLoader, path: "./priv/repo/seeds/family_guy.yml"
# end

# IO.inspect(MyApp.name())
# IO.inspect(MyApp.quote())
