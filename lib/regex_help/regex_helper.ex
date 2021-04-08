defmodule RegexHelper do
  use Rustler, otp_app: :regex_help, crate: "regexhelper"

  defmodule Flags do
    defstruct digits: false,
              spaces: false,
              words: false,
              repetitions: false,
              ignore_case: false,
              capture_groups: false
  end

  def build(s, flags) do
    case s do
      "" ->
        ""

      query ->
        build_expression(
          query,
          flags.digits,
          flags.spaces,
          flags.words,
          flags.repetitions,
          flags.ignore_case,
          flags.capture_groups
        )
    end
  end

  defp build_expression(_s, _d, _sp, _w, _r, _i, _cg), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
