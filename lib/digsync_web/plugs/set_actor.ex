defmodule DigsyncWeb.Plugs.SetActor do
  def init(opts), do: opts

  def call(conn, _opts) do
    Ash.PlugHelpers.set_actor(conn, conn.assigns.current_user)
  end
end
