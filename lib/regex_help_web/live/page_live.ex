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
      |> assign(lines: [])
      |> assign(flags: %RegexHelper.Flags{})

    {:ok, socket}
  end

  @impl true
  def handle_event("update_query", %{"value" => query}, socket) do
    case String.length(query) > 1000 do
      true -> {:noreply, put_flash(socket, :error, "Input too long, 1000 chars max.")}
      false -> {:noreply, update_generated(socket, query, socket.assigns.flags)}
    end
  end

  def handle_event("update_regex_custom", %{"value" => regex_custom}, socket) do
    {:noreply, update_custom(socket, regex_custom)}
  end

  def handle_event("set_flag", %{"flag" => flag, "enabled" => enabled}, socket) do
    flags = update_flags(socket.assigns.flags, flag, enabled == "true")
    {:noreply, update_generated(socket, socket.assigns.query, flags)}
  end

  def handle_event("copy_generated", _params, socket) do
    {:noreply, update_custom(socket, socket.assigns.regex_generated)}
  end

  defp update_generated(socket, query, flags) do
    socket
    |> clear_flash()
    |> assign(query: query)
    |> assign(flags: flags)
    |> assign(regex_generated: RegexHelper.build(query, flags))
    |> update_custom(socket.assigns.regex_custom)
  end

  defp update_custom(socket, regex_custom) do
    lines = String.split(socket.assigns.query, "\n")

    socket
    |> assign(:regex_custom, regex_custom)
    |> assign(:matches, RegexHelper.check(lines, regex_custom))
    |> assign(:lines, lines)
  end

  defp update_flags(flags, flag_name, flag_value) do
    case is_valid_flag(flag_name) do
      true ->
        updated_flag = %{flags.flag_name | value: flag_value}
        Map.put(flags, String.to_atom(flag_name), updated_flag)
      false ->
        flags
    end
  end

  defp is_valid_flag(flag_name) do
    %RegexHelper.Flags{}
    |> Map.keys()
    |> Enum.reject(&(&1 == :__struct__))
    |> Enum.member?(flag_name)
  end
end
