defmodule Digsync.Accounts.Users do
  alias Digsync.Accounts
  alias Digsync.Accounts.User

  @spec get(String.t()) :: {:ok, User.t()} | {:ok, nil} | {:error, Ash.Error.Invalid.t()}
  def get(id), do: Accounts.get(User, id)

  @spec create(map(), User.t()) :: {:ok, User.t()} | {:error, any()}
  def create(params, actor) do
    User
    |> Ash.Changeset.for_create(:create, params, actor: actor)
    |> Accounts.create()
  end

  @spec update(User.t(), map(), User.t()) :: {:ok, User.t()} | {:error, any()}
  def update(user, params, actor) do
    user
    |> Ash.Changeset.for_update(:update, params, actor: actor)
    |> Accounts.update()
  end

  @spec list_all() :: {:ok, [User.t()]} | {:error, any()}
  def list_all() do
    User
    |> Ash.Query.for_read(:read)
    |> Accounts.read()
  end

  @spec get_by_first_and_last(String.t(), String.t()) :: User.t() | nil
  def get_by_first_and_last(first_name, last_name) do
    User
    |> Ash.Query.for_read(:by_first_and_last, %{first_name: first_name, last_name: last_name})
    |> Accounts.read()
  end

  @spec me(User.t()) :: {:ok, User.t()} | {:error, any()}
  def me(actor) do
    User
    |> Ash.Query.for_read(:current_user, actor: actor)
    |> Accounts.read_one()
  end
end
