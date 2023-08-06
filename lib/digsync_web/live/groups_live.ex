defmodule DigsyncWeb.GroupsLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Group

  def mount(_params, _session, socket) do
    socket = assign(socket, groups: fetch_groups())
    {:ok, socket}
  end

  def fetch_groups() do
    Group
      |> Accounts.read!()
  end

  def create_group() do

  end


end
