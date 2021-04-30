import Config

config :regex_help, RegexHelpWeb.Endpoint, force_ssl: [rewrite_on: [:x_forwarded_proto]]
