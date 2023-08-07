defmodule DigsyncWeb.LiveAuth do
  @moduledoc """
    This module is going to serve as our Authentication into our LiveView Routes.
    Currently uses must be signed in to access any internal liveview. Authentication happens
    first in the "ash_authentication_live_session" macro in the router which assigns
    the current_user to the socket. As such this module is pattern matching on whether
    or not the current user is actually on the socket. It would be near impossible to spoof
    this behaviour but eventually we may want to add an authenticity check on the User struct
    to make sure that we were the one's that actually created them for security purposes.

    The on_mount callback can either return {:cont, socket} or {:halt, socket}. The :default name
    is required here as we are not supplying any options when calling the on_mount macro in
    the router.
  """

  import Phoenix.LiveView, only: [redirect: 2]
  alias Digsync.Accounts.User
  alias DigsyncWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, _session, %{assigns: %{current_user: %User{}}} = socket) do
    {:cont, socket}
  end

  def on_mount(:default, _params, _session, socket) do
    home_page = Routes.page_path(socket, :home, %{"authentication_required" => true})
    {:halt, redirect(socket, to: home_page)}
  end
end
