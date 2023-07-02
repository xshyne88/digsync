defmodule Digsync.Accounts do
  use Ash.Api,
    extensions: [
      AshGraphql.Api
    ],
    otp_app: :digsync

  resources do
    registry Digsync.Accounts.Registry
  end

  graphql do
    authorize? false
  end
end
