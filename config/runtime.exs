import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  app_name = System.get_env("FLY_APP_NAME") || raise "FLY_APP_NAME not available"

  config :regex_help, RegexHelpWeb.Endpoint,
    server: true,
    url: [host: "regex.help", port: 80],
    check_origin: [
      "https://regex.help",
      "https://#{app_name}.fly.dev"
    ],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: secret_key_base
end
