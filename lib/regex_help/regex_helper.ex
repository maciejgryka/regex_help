defmodule RegexHelper do
  use Rustler, otp_app: :regex_help, crate: "regexhelper"

  @type flag :: boolean()

  defmodule Flags do
    defstruct digits: %{value: false, description: "Convert digits to \\d"},
              spaces: %{value: false, description: "Convert whitespace to \\s"},
              words: %{value: false, description: "Convert any Unicode word character to \\w"},
              repetitions: %{
                value: false,
                description: "Convert repeated substrings to {min,max}"
              },
              ignore_case: %{value: false, description: "Ignore capitalization"},
              capture_groups: %{value: false, description: "Use capturing groups"},
              verbose: %{value: false, description: "Multi-line output"},
              escape: %{value: false, description: "Escape non-ASCII characters"}

    @type t :: %__MODULE__{
            digits: %{},
            spaces: %{},
            words: %{},
            repetitions: %{},
            ignore_case: %{},
            capture_groups: %{},
            verbose: %{},
            escape: %{}
          }

    @spec names :: list
    def names do
      %__MODULE__{}
      |> Map.keys()
      |> Enum.reject(&(&1 == :__struct__))
    end
  end

  @spec build(String.t(), Flags.t()) :: String.t()
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
          flags.capture_groups.value,
          flags.verbose.value,
          flags.escape.value
        )
    end
  end

  @spec check([String.t()], String.t()) :: boolean()
  def check(_query, _regex), do: error()

  @spec build_expression(String.t(), flag, flag, flag, flag, flag, flag, flag, flag) :: String.t()
  defp build_expression(_s, _d, _sp, _w, _r, _i, _cg, _v, _e), do: error()

  defp error, do: :erlang.nif_error(:nif_not_loaded)
end
