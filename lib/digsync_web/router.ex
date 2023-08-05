defmodule DigsyncWeb.Router do
  use DigsyncWeb, :router
  use AshAuthentication.Phoenix.Router

  import AshAdmin.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {DigsyncWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:load_from_session)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:load_from_bearer)
  end

  pipeline :graphql do
    plug(:fetch_session)
    plug(:load_from_session)
    plug(DigsyncWeb.Plugs.SetActor)
    plug(AshGraphql.Plug)
  end

  scope "/", DigsyncWeb do

    pipe_through(:browser)

    get("/", PageController, :home)

    live_session :default do
      live("/users", UsersLive)
      live("/users/:id", UserDetailsLive)
    end

    sign_in_route()
    sign_out_route(AuthController)
    auth_routes_for(Digsync.Accounts.User, to: AuthController)
    reset_route([])
  end

  scope "/dev" do
    pipe_through(:browser)
    ash_admin("/admin")
  end

  scope "/graphql" do
    pipe_through(:graphql)

    forward("/api", Absinthe.Plug, schema: DigsyncWeb.Schema)

    forward("/playground", Absinthe.Plug.GraphiQL,
      schema: DigsyncWeb.Schema,
      interface: :advanced
    )
  end

  # Other scopes may use custom stacks.
  # scope "/api" do
  #   pipe_through [:api, :graphql]

  #   # forward "/gql", Absinthe.Plug, schema: DigsyncWeb.Schema

  #   forward "/playground",
  #     to: Absinthe.Plug.GraphiQL,
  #     init_opts: [
  #       schema: DigsyncWeb.Schema,
  #       interface: :playground
  #     ]
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:digsync, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: DigsyncWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
