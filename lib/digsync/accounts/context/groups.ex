defmodule Digsync.Accounts.Groups do
  alias Digsync.Accounts
  alias Digsync.Accounts.Group
  alias Digsync.Accounts.User

  require Ash.Query
  require Logger

  @spec get_by_id(String.t(), User.t(), list(atom())) :: Group.t() | nil | {:error, any()}
  def get_by_id(group_id, actor, relationships \\ []) do
    Group
    |> Accounts.get(group_id)
    |> case do
      {:ok, group} ->
        load_relationships(group, actor, relationships)

      error ->
        Logger.error(inspect(error))
        error
    end
  end

  @spec all_groups(User.t(), list(atom())) :: {:ok, list(Group.t())} | {:error, any()}
  def all_groups(actor, relationships \\ []) do
    Group
    |> Ash.Query.set_actor(actor: actor)
    |> load_relationships(relationships)
    |> Accounts.read()
  end

  defp load_relationships(%Ash.Query{} = query, []), do: query

  defp load_relationships(%Ash.Query{} = query, relationships) do
    Ash.Query.load(query, filter_loadable_relationships(relationships))
  end

  defp load_relationships(%Group{} = group, _actor, []), do: group

  defp load_relationships(%Group{} = group, actor, relationships) do
    Accounts.load!(group, filter_loadable_relationships(relationships), actor: actor)
  end

  defp filter_loadable_relationships(relationships) do
    relationship_names =
      Group
      |> Ash.Resource.Info.relationships()
      |> Enum.filter(fn
        %Ash.Resource.Relationships.ManyToMany{} = _ -> true
        %Ash.Resource.Relationships.BelongsTo{} = _ -> true
        _ -> false
      end)
      |> Enum.map(& &1.name)

    Enum.filter(relationships, &(&1 in relationship_names))
  end
end
