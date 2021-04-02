defmodule RegexHelper do
  use Rustler, otp_app: :regex_help, crate: "regexhelper"

  def reverse(_s), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
