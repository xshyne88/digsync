defmodule Digsync.Accounts.GroupRequests do
  alias Digsync.Accounts
  alias Digsync.Accounts.GroupRequest
  require Ash.Query

  def get(id) do
    GroupRequest
    |> Ash.Query.for_read(:by_id, %{id: id})
    |> Accounts.read_one()
    |> case do
      {:ok, nil} -> {:error, :not_found}
      {:ok, group_request} -> {:ok, group_request}
    end
  end

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
