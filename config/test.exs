import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :digsync, Digsync.Repo,
  username: System.get_env("DB_USERNAME"),
  password: "postgres",
  hostname: "localhost",
  database: "digsync_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :digsync, DigsyncWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "2U4eHde17RzFcvMhA3rF/FYfzKK8yCbKBKoFLljHfr2Yahdm2QfFkFjskqy3edTh",
  server: false

# In test we don't send emails.
config :digsync, Digsync.Mailer, adapter: Swoosh.Adapters.Test

# we don't need ash to spawn tasks during tests
config :ash, :disable_async?, true

# notifiers run in some transactions and its mostly not necessary in tests.
config :ash, :missed_notifications, :ignore

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
