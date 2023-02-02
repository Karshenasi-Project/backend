# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :backend,
  ecto_repos: [Backend.Repo]

# Configures the endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BackendWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Backend.PubSub,
  live_view: [signing_salt: "6tyuzN+3"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :backend, Backend.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :backend, Backend.Accounts.Guardian,
issuer: "test",
secret_key: "EDzKyR0ZfL4Rsm3o90YbEIdiwooM0TH5JEsk1PTlR8SZ0y0a6kgGi2tmXfy1b2nN" # put the result of the mix command above here

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
