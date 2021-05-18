defmodule RegexHelpWeb.MetricsController do
  use RegexHelpWeb, :controller

  alias RegexHelpWeb.Metrics

  def index(conn, _params) do
    conn = assign(conn, :num_visits, Metrics.num_visits())
    render(conn, "index.html")
  end
end
