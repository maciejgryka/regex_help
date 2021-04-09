defmodule RegexHelpWeb.AboutController do
  use RegexHelpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
