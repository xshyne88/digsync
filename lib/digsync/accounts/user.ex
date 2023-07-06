# lib/my_app/accounts/user.ex

defmodule Digsync.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshGraphql.Resource]

  postgres do
    table("users")
    repo(Digsync.Repo)
  end

  attributes do
    uuid_primary_key(:id)

    attribute :email, :ci_string do
      allow_nil?(false)

      constraints(match: ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$/)
    end

    attribute :user_type, :atom do
      default(:user)
      constraints(one_of: [:admin, :user, :guest])
    end

    attribute :create_type, :atom do
      default(:password)
      constraints(one_of: [:password, :oauth2, :system])
    end

    attribute(:address, :string)

    attribute(:hashed_password, :string, allow_nil?: false, sensitive?: true)
    attribute(:first_name, :string)
    attribute(:last_name, :string)
    attribute(:phone_number, :string)

    attribute(:facebook_link, :string)
    attribute(:instagram_link, :string)
    attribute(:linkedin_link, :string)
    attribute(:github_link, :string)

    attribute :gender, :atom do
      default(:male)
      constraints(one_of: Digsync.Types.Gender.values())
    end

    attribute :age, :integer do
      constraints(min: 18, max: 99)
    end

    attribute(:bio, :string)

    attribute :skill_level, :atom do
      constraints(one_of: Digsync.Types.SkillLevel.values())
    end

    create_timestamp(:inserted_at, private?: false, allow_nil?: false)
    create_timestamp(:updated_at, private?: false, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :update, :destroy])

    read :current_user do
      get?(true)

      filter(id: actor(:id))
    end
  end

  # relationships do
  #   many_to_many :friendships, Digsync.Account.User do
  #     through Digsync.Accounts.Friendship
  #     destination_attribute_on_join_resource :user_id
  #     source_attribute_on_join_resource :user_id
  #   end
  # end

  graphql do
    type(:user)
    hide_fields([:hashed_password])

    queries do
      get(:get_user, :read)

      read_one(:me, :current_user)

      list(:list_users, :read)
    end

    mutations do
      create(:create_user, :create)
      update(:update_user, :update)
      destroy(:destroy_user, :destroy)
    end
  end

  authentication do
    api(Digsync.Accounts)

    strategies do
      magic_link do
        identity_field(:email)

        sender(Digsync.Accounts.Users.Senders.MagicLink)
      end

      password :password do
        identity_field(:email)
        sign_in_tokens_enabled?(true)

        resettable do
          sender(Digsync.Accounts.User.Senders.SendPasswordResetEmail)
        end
      end
    end

    tokens do
      enabled?(true)
      token_resource(Digsync.Accounts.Token)

      signing_secret(Application.compile_env(:digsync, DigsyncWeb.Endpoint)[:secret_key_base])
    end
  end

  identities do
    identity(:unique_email, [:email])
  end

  # If using policies, add the folowing bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
