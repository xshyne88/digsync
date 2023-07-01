defmodule Digsync.Repo do
  use Ecto.Repo,
    otp_app: :digsync,
    adapter: Ecto.Adapters.Postgres
end
