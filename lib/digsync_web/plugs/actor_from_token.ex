defmodule DigsyncWeb.Plugs.ActorFromToken do
  # import Ash.PlugHelpers
  def init(opts), do: opts

  def call(conn, _opts) do
    Plug.Conn.get_req_header(conn, "authorization") |> IO.inspect(label: "authorization")
    IO.inspect(conn)
    # IO.inspect(Plug.Conn.get_session(conn))
    # if auth do
    conn
    # |> set_actor()
    # end
  end
end
