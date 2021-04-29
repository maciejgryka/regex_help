import Config

# Configures the endpoint
config :regex_help, RegexHelpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xdqLDKRddKYYyU0EZxOR+1OypwmCGgQZeHu8hwgIyK/WWeZVTCJlvRyRcn02ew3k",
  render_errors: [view: RegexHelpWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: RegexHelp.PubSub,
  live_view: [signing_salt: "66fFbKY8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :debug

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
