defmodule Digsync.Accounts do
  use Ash.Api,
    extensions: [
      AshGraphql.Api,
      AshAdmin.Api
    ],
    otp_app: :digsync

  resources do
    registry Digsync.Accounts.Registry
  end

  graphql do
    authorize? true
  end
end
