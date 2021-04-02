defmodule RegexHelpWeb.PageLive do
  use RegexHelpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", results: %{})}
  end

  @impl true
  def handle_event("update_username", %{"value" => query}, socket) do
    {:noreply, assign(socket, query: query)}
  end
end
