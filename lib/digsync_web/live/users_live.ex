defmodule DigsyncWeb.UsersLive do
  use DigsyncWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, users: Digsync.Accounts.read!(Digsync.Accounts.User))
    {:ok, socket}
  end

end
