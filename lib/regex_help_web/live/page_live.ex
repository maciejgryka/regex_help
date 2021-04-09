defmodule RegexHelpWeb.PageLive do
  use RegexHelpWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(query: "")
      |> assign(regex_generated: "")
      |> assign(regex_custom: "")
      |> assign(matches: [])
      |> assign(flags: %RegexHelper.Flags{})

    {:ok, socket}
  end

  @impl true
  def handle_event("update_query", %{"value" => query}, socket) do
    IO.inspect(query)
    {:noreply, build_query(socket, query, socket.assigns.flags)}
  end

  def handle_event("update_regex_custom", %{"value" => regex_custom}, socket) do
    lines = String.split(socket.assigns.query, "\n")
    matches = Enum.map(lines, fn line -> RegexHelper.check(line, regex_custom) end)

    socket =
      socket
      |> assign(:regex_custom, regex_custom)
      |> assign(:matches, matches)

    {:noreply, socket}
  end

  def handle_event("set_flag", %{"flag" => flag, "enabled" => enabled}, socket) do
    flags = update_flags(socket.assigns.flags, flag, enabled == "true")
    {:noreply, build_query(socket, socket.assigns.query, flags)}
  end

  defp build_query(socket, query, flags) do
    socket
    |> assign(query: query)
    |> assign(flags: flags)
    |> assign(regex_generated: RegexHelper.build(query, flags))
  end

  defp update_flags(flags, flag_name, flag_value) do
    case is_valid_flag(flag_name) do
      true -> Map.put(flags, String.to_atom(flag_name), flag_value)
      false -> flags
    end
  end

  defp is_valid_flag(flag_name) do
    Enum.member?(
      ["digits", "spaces", "words", "repetitions", "ignore_case", "capture_groups"],
      flag_name
    )
  end
end
