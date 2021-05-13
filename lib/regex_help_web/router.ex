defmodule RegexHelpWeb.Router do
  use RegexHelpWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RegexHelpWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  scope "/", RegexHelpWeb do
    pipe_through :browser

    get "/about", AboutController, :index
    live "/", PageLive, :index
  end

  scope "/" do
    pipe_through [:browser, :admins_only]
    live_dashboard "/dashboard", metrics: RegexHelpWeb.Telemetry
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
