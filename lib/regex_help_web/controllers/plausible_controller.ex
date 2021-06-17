defmodule RegexHelpWeb.PlausibleController do
  use RegexHelpWeb, :controller

  def script(conn, _params) do
    redirect(conn, external: "https://plausible.io/js/plausible.js")
  end
end
