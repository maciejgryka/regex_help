defmodule RegexHelpWeb.PageLiveTest do
  use RegexHelpWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    conn = Map.put(conn, :host, "localhost")
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Enter your examples here:"
    assert render(page_live) =~ "Enter your examples here:"
  end

  test "non-localhost requests get redirected to HTTPS", %{conn: conn} do
    original_host = conn.host
    redirected_to = "https://#{original_host}/"
    {:error, {:redirect, %{to: ^redirected_to}}} = live(conn, "/")
  end
end
