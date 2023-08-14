import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :digsync, DigsyncWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :digsync, :phoenix_sass,
  # this is the default
  pattern: "sass/**/*.s[ac]ss",
  # this is the default
  output_dir: "static/css",
  # this is the default (compressed)
  output_style: 3

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: Digsync.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
