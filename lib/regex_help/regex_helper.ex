defmodule RegexHelper do
  use Rustler, otp_app: :regex_help, crate: "regexhelper"

  defmodule Flags do
    defstruct digits: %{value: false, description: "Convert digits to \\d"},
              spaces: %{value: false, description: "Convert whitespace to \\s"},
              words: %{value: false, description: "Convert any Unicode word character to \\w"},
              repetitions: %{value: false, description: "Convert repeated substrings to {min,max}"},
              ignore_case: %{value: false, description: "Ignore capitalization"},
              capture_groups: %{value: false, description: "Use capturing groups"}
  end

  def build(s, flags) do
    case s do
      "" ->
        ""

      query ->
        build_expression(
          query,
          flags.digits.value,
          flags.spaces.value,
          flags.words.value,
          flags.repetitions.value,
          flags.ignore_case.value,
          flags.capture_groups.value
        )
    end
  end

  def check(_query, _regex), do: error()
  defp build_expression(_s, _d, _sp, _w, _r, _i, _cg), do: error()
  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
