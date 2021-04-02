defmodule RegexHelpWeb.PageLive do
  use RegexHelpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, help_response: "", results: %{})}
  end

  @impl true
  def handle_event("update_username", %{"value" => query}, socket) do
    yreuq = RegexHelper.reverse(query)
    {:noreply, assign(socket, help_response: yreuq)}
  end
end
