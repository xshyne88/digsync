defmodule DigsyncWeb.GroupDetailsLive do
  use DigsyncWeb, :live_view
  alias Digsync.Accounts.Group

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def fetch_groups() do

  end


end
