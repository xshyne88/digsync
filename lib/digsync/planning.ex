defmodule Digsync.Planning do
  use Ash.Api,
    extensions: [
      AshGraphql.Api
    ],
    otp_app: :digsync

  resources do
    registry Digsync.Planning.Registry
  end

  graphql do
    authorize? true
  end
end
