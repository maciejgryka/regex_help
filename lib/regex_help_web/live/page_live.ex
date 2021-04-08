defmodule RegexHelpWeb.PageLive do
  use RegexHelpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: "")
      |> assign(help_response: "")
      |> assign(flags: %RegexHelper.Flags{})
    {:ok, socket}
  end

  @impl true
  def handle_event("update_query", %{"value" => query}, socket) do
    {:noreply, build_query(socket, query, socket.assigns.flags)}
  end

  def handle_event("set_flag_repetitions", params, socket) do
    IO.inspect(params)
    enabled = Map.get(params, "value") == "true"
    flags = %RegexHelper.Flags{socket.assigns.flags | repetitions: enabled}


    {:noreply, build_query(socket, socket.assigns.query, flags)}
  end

  defp build_query(socket, query, flags) do
    new_expression = RegexHelper.build(query, flags)
    socket
    |> assign(query: query)
    |> assign(flags: flags)
    |> assign(help_response: new_expression)
  end
end
