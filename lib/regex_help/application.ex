defmodule RegexHelp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      RegexHelp.PromEx,
      # Start the Telemetry supervisor
      RegexHelpWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RegexHelp.PubSub},
      # Start the Endpoint (http/https)
      RegexHelpWeb.Endpoint
      # Start a worker by calling: RegexHelp.Worker.start_link(arg)
      # {RegexHelp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RegexHelp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RegexHelpWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
