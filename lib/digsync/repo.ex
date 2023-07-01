defmodule Digsync.Repo do
  use AshPostgres.Repo, otp_app: :digsync

  def installed_extensions do
    ["uuid-ossp", "citext"]
  end
end
