import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host =
    System.get_env("HOST") ||
      raise """
      environment variable HOST is missing.
      """

  config :regex_help, RegexHelpWeb.Endpoint,
    server: true,
    url: [host: host, port: 80],
    check_origin: ["https://regex.help", "https://regex-help-stg.fly.dev/"],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: secret_key_base

  config :regex_help, RegexHelp.PromEx,
    manual_metrics_start_delay: :no_delay,
    grafana: [
      host: System.get_env("GRAFANA_HOST") || raise("GRAFANA_HOST is required"),
      auth_token: System.get_env("GRAFANA_TOKEN") || raise("GRAFANA_TOKEN is required"),
      upload_dashboards_on_start: true,
      folder_name: "promex",
      annotate_app_lifecycle: true
    ]
end
