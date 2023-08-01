defmodule DigsyncWeb.UserController do
  use DigsyncWeb, :controller

  def get_users(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :user, layout: false)
  end
end
