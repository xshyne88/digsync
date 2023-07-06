defmodule Digsync.Accounts.Users.Senders.MagicLink do
  @moduledoc """
  Sends a magic link
  """
  use AshAuthentication.Sender
  use DigsyncWeb, :verified_routes

  @impl AshAuthentication.Sender
  def send(user, token, _) do
    Digsync.Accounts.Emails.deliver_magic_link(
      user,
      url(~p"/auth/user/magic_link/?token=#{token}")
    )
  end
end
