defmodule RegexHelpWeb.PageLiveTest do
  use RegexHelpWeb.ConnCase

  import Phoenix.LiveViewTest

  test "disconnected and connected render", %{conn: conn} do
    {:ok, page_live, disconnected_html} = live(conn, "/")
    assert disconnected_html =~ "Enter your examples here:"
    assert render(page_live) =~ "Enter your examples here:"
  end
end
