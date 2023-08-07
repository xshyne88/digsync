defmodule Digsync.Accounts.Groups do
  alias Digsync.Accounts
  alias Digsync.Accounts.Group

  @spec get(String.t()) :: {:ok, Group.t()} | {:ok, nil} | {:error, Ash.Error.Invalid.t()}
  def get(id), do: Accounts.get(Group, id)
end
