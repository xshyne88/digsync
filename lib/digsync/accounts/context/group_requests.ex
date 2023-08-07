defmodule Digsync.Accounts.GroupRequests do
  alias Digsync.Accounts
  alias Digsync.Accounts.GroupRequest
  require Ash.Query

  @spec get(String.t()) :: {:ok, GroupRequest.t()} | {:error, :not_found}
  def get(id) do
    GroupRequest
    |> Ash.Query.for_read(:by_id, %{id: id})
    |> Ash.Query.load([:requester, :group])
    |> Accounts.read_one(authorize?: false)
    |> case do
      {:ok, nil} -> {:error, :not_found}
      {:ok, group_request} -> {:ok, group_request}
    end
  end

  @spec accepted(String.t()) :: {:ok, GroupRequest.t()} | any()
  def accepted(%GroupRequest{} = group_request) do
    group_request
    |> Ash.Changeset.for_destroy(:soft)
    |> Accounts.destroy()
    |> case do
      :ok -> {:ok, group_request}
      error -> error
    end
  end
end
