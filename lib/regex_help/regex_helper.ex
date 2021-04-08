defmodule RegexHelper do
  use Rustler, otp_app: :regex_help, crate: "regexhelper"

  defmodule Flags do
    defstruct repetitions: false, digits: false
  end

  def build(s, flags) do
    case s do
      "" -> ""
      query -> build_expression(query, flags.repetitions)
    end
  end

  defp build_expression(_s, _repetitions), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
